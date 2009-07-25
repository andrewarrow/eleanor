# Copyright (c) 2008 chiisaitsu <chiisaitsu@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'eleanor/length'
require 'eleanor/parser'
require 'yaml'

module Eleanor

  # Program name
  NAME= 'Eleanor'

  # Program version
  VERSION= '1.0.0'

  # Loads a YAML config file from +filename+.  Must be called before anything
  # else is done.  This method creates class and instance methods corresponding
  # to the options defined in the YAML.  See "Configuration" in the README.
  def self.load_config filename
    config= YAML.load_file(filename)
    Length.line_height= config['Screenplay']['line_height_points']
    config.each_pair do |class_name, hash|
      klass= const_get(class_name)
      hash.each_pair do |att_name, att_val|
        # define a class method that just returns the value of the trait
        (class << klass; self; end).instance_eval do
          define_method(att_name) { att_val }
        end
        # define an instance method that attempts to eval the trait if it's a
        # string and just returns its value otherwise.  the method may be passed
        # a hash; each key in the hash is made avaiable to the eval'ed code as a
        # function that returns the key's value.
        klass.class_eval do
          define_method(att_name) do |*args|
            args= args[0] || {}
            if att_val.is_a? String
              closure= self.dup
              (class << closure; self; end).instance_eval do
                args.each_pair do |arg_name, arg_val|
                  define_method(arg_name) { arg_val }
                end
              end
              closure.instance_eval do
                begin
                  eval(att_val)
                rescue StandardError, SyntaxError
                  att_val
                end
              end
            else
              att_val
            end
          end
        end
      end
    end
  end

  # Returns a new Screenplay created by parsing the plain text screenplay
  # at +filename+.  If parsing fails, returns +nil+.
  def self.parse filename
    screenplay= Screenplay.new
    screenplay.parse!(filename) and screenplay or nil
  end



  # Base Paragraph class from which all paragraphs inherit.
  #
  # Note that Eleanor.load_config dynamically adds both class and instance
  # methods to Paragraph and its subclasses depending on the options present in
  # the user's configuration file.  See "Configuration" in the README.
  class Paragraph

    # Set by pagination
    attr_accessor :is_first_on_page

    # See initialize
    attr_reader   :input_line, :last_character_cue, :screenplay, :split_state

    # Array of lines in the paragraph
    attr_reader   :lines

    # The height (a Length) of the paragraph given its screenplay's line height
    # and the number of lines in the paragraph.
    def height
      @screenplay.line_height * @lines.size
    end

    # A paragraph must be attached to a +screenplay+.  +input_line+ is the line
    # of raw text used to build the paragraph.  +last_character_cue+ should be
    # a reference to the last CharacterCue paragraph seen in the input and is
    # used to keep track of Dialog continuations.  +split_state+ should be one
    # of :whole, :orphan, or :widow and indicates if the paragraph is intact on
    # one page, split across pages and at the bottom of the first page, or split
    # across pages and at the top of the second page.
    def initialize screenplay, input_line, last_character_cue, split_state=:whole
      @screenplay= screenplay
      @last_character_cue= last_character_cue
      @split_state= split_state
      @is_first_on_page= false
      @input_line= (self.respond_to?(:text) ? self.text : input_line)
      @fixed_line= fix_input_line
      @sentences= @fixed_line.split(/ {2,}/)
      break_lines!
    end

    # Returns true if the paragraph should be kept on the same page as +para+.
    def keep_with_next? para
      if self.class.keep_with_nexts.is_a? Array
        self.class.keep_with_nexts.include? para.class.name[/[^:]+$/]
      else
        self.keep_with_nexts(:next_para => para)
      end
    end

    # Returns the Length between the paragraph and +para+.
    def margin_between para
      [self.margin_bottom(:next_para => para),
       para.margin_top(:prev_para => self)].max
    end

    # Splits the paragraph across a page break, respecting orphan and widow
    # sentences and lines.  Returns [orphan, widow], where orphan is a new
    # paragraph suitable for the bottom of the existing page, and widow is a
    # new paragraph suitable for the top of a new page.  orphan's height will
    # be no more than +max_orphan_height+ (a Length).  If such constraints cannot
    # be satisfied, the paragraph cannot be broken, and [+nil+, +self+] is
    # returned.
    def split max_orphan_height
      if !self.can_break_across_pages ||
          @sentences.size < (self.min_orphan_sentences_allowed +
                             self.min_widow_sentences_allowed)
        return [nil, self]
      end
      # [[orphan_para, widow_para] | orphan_para has
      #   self.class.min_orphan_sentences_allowed sentences, ... ]
      # assume self.class.min_orphan_sentences_allowed >= 1
      # assume self.class.min_widow_sentences_allowed >= 1
      lo= self.min_orphan_sentences_allowed - 1
      hi= @sentences.size - self.min_widow_sentences_allowed - 1
      (lo..hi).inject([]) do |paras, i|
        orphan= slice(0..i, :orphan)
        break paras if orphan && orphan.height > max_orphan_height
        widow= slice((i + 1)..-1, :widow)
        paras << [orphan, widow]
      end.reverse_each do |paras|
        if paras[0].lines.size >= self.min_orphan_lines_allowed &&
            paras[1].lines.size >= self.min_widow_lines_allowed
          return paras
        end
      end
      [nil, self]
    end

    def to_s
      "[#{self.class.name[/[^:]+$/]}] #{@input_line}"
    end

    private

    # Breaks the fixed input line into an array of lines according to the width
    # of the paragraph.
    def break_lines! hanging_indent=0
      @lines= ['']
      @sentences.each do |sentence|
        sentence.split(/ /).each do |term|
          # term is a single word that either contains hyphens or doesn't
          term.scan(/[^-]+-+|[^-]+|-+/) do |word|
            # word either contains no hyphens, ends in hyphens, or is only
            # hyphens
            width= @screenplay.text_width(@lines.last + word)
            # new line needed
            if width > self.width
              @lines.last.rstrip!
              indent_str= (' ' * hanging_indent)
              # if word is just hyphens, it shouldn't start a line.  chop the
              # tail of the last line, move it to the front of the new line.
              if /^-+$/ =~ word
                tail= nil
                @lines.last.sub!(/\s*[^\s]+$/) do |match|
                  tail= "#{match} "
                  ''
                end
                @lines.pop if @lines.last.empty?
                @lines << indent_str + tail.lstrip
              else
                @lines << indent_str
              end
            end
            @lines.last << word
          end
          @lines.last << ' '
        end
        @lines.last << ' '
      end
      @lines.last.rstrip!
      if self.limit_to_one_line && @lines.size > 1
        raise "pagination error: line too long: attempted to break #{self}"
      end
      @lines
    end

    # Some subclasses (e.g., a continued CharacterCue) need to massage the
    # input line in some way.
    def fix_input_line
      @input_line
    end

    # Returns a new paragraph whose sentences are those of this paragraph in
    # the range of +sentence_range+.  The new paragraph will have the given
    # +split_state+.
    def slice sentence_range, split_state
      self.class.new(@screenplay,
                     @sentences[sentence_range].join('  '),
                     @last_character_cue,
                     @split_state)
    end

  end

  class Action < Paragraph; end

  class CharacterCue < Paragraph

    private

    # Tacks on widow and continuation modifiers as necessary.
    def fix_input_line
      line= @input_line.upcase
      contd_str=
        if @split_state == :widow
          widow_modifier
        elsif @last_character_cue &&
            @last_character_cue.input_line == @input_line
          continuation_modifier
        else
          nil
        end
      if contd_str.nil? || contd_str.empty?
        line
      else
        regex= /\)\s*$/
        if regex =~ line
          line.sub(regex, ", #{contd_str})")
        else
          "#{line} (#{contd_str})"
        end
      end
    end

  end

  class Dialog < Paragraph; end

  class Insert < Paragraph; end

  class MontageHeading < Paragraph; end

  class MontageItem < Paragraph
    private
    def break_lines!
      super(3)
    end
  end

  # When a Dialog is split across two pages, a More paragraph will be added as
  # the last paragraph on the first page.
  class More < Paragraph
    def initialize screenplay
      super(screenplay, nil, nil, :whole)
    end
  end

  class Parenthetical < Paragraph
    private
    def break_lines!
      super(1)
    end
  end

  class SceneHeading < Paragraph
    private
    def fix_input_line
      @input_line.upcase
    end
  end

  class SlugLine < Paragraph; end

  class Transition < Paragraph; end



  # Encapsulates paragraphs.
  #
  # Note that Eleanor.load_config dynamically adds both class and instance
  # methods to Page and its subclasses depending on the options present in the
  # user's configuration file.  See "Configuration" in the README.
  class Page

    # See initialize
    attr_reader :page_no, :screenplay

    # Array of Paragraphs
    attr_reader :paras

    # The page's body is all the paragraphs (and the margins between them)
    # between the page's top and bottom margins.  Returns a Length.
    def body_height
      prev_para= nil
      @paras.inject(0.points) do |total, para|
        prev, prev_para= [prev_para, para]
        total + para.height + (prev.nil?? 0.points : prev.margin_between(para))
      end
    end

    # Pages must be attached to a +screenplay+.  +page_no+ is the page number.
    def initialize screenplay, page_no
      @screenplay= screenplay
      @page_no= page_no
      @paras= []
    end

    # The page's top margin plus the top margin of the first paragraph on the
    # page.  A Length.
    def margin_top_actual
      self.margin_top + (@paras.empty?? 0.points : @paras.first.margin_top)
    end

    # The page's maximum body height (see body_height) given its top and bottom
    # margins.
    def max_body_height
      self.height - self.margin_top_actual - self.margin_bottom
    end

    # Attempts to add +para+ to the end of the page.  If +para+ is split by the
    # page break as a result or cannot be added at all, returns a new Paragraph
    # which should be added to the top of a new page.  Otherwise, if +para+ fits
    # on the page, +nil+ is returned.  If +force+ is true +para+ is added to the
    # page regardless of constraints.
    def push_para para, force=false
      prev_para= @paras.last
      if prev_para.nil? && (para.is_a?(Dialog) || para.is_a?(Parenthetical))
        prev_para= CharacterCue.new(para.screenplay,
                                    para.last_character_cue.input_line,
                                    nil,
                                    :widow)
        self.push_para(prev_para)
      end
      margin_between= (prev_para.nil?? 0.points : prev_para.margin_between(para))
      height_before_para= self.body_height + margin_between
      # para overruns the current page.  need to start a new page.
      curr_page_para, new_page_para=
        if (height_before_para + para.height > self.max_body_height) && !force
          if height_before_para >= self.max_body_height
            [nil, para]
          else
            orphan, widow= para.split(self.max_body_height - height_before_para)
            if orphan.nil?
              [nil, para]
            else
              [orphan, widow]
            end
          end
        else
          [para, nil]
        end
      unless curr_page_para.nil?
        curr_page_para.is_first_on_page= true if @paras.empty?
        @paras << curr_page_para
      end
      new_page_para
    end

    def to_s
      str= '- ' + @page_no.to_s + ' ' + ('-' * 72) + "\n"
      @paras.inject(str) { |s, para| "#{s}#{para}\n"}
    end

  end



  # Encapsulates paragraphs and pages.
  #
  # Note that Eleanor.load_config dynamically adds both class and instance
  # methods to Screenplay depending on the options present in the user's
  # configuration file.  See "Configuration" in the README.
  class Screenplay

    # Array of Page objects.  Filled in during pagination.
    attr_reader :pages

    # Array of Paragraph objects.  Filled in during parsing, used during
    # pagination.
    attr_reader :paras

    # Array of TitlePage objects.  Filled in during parsing.
    attr_reader :title_pages

    # The screenplay's author, nil if none.
    def author
      @title_pages.each { |tp| tp.author and return tp.author }
      nil
    end

    def initialize
      @paras= []
      @title_pages= []
      @pages= [Page.new(self, 1)]
      initialize_paper!
    end

    # Paginates the screenplay according to its and all the constraints of its
    # paragraphs.
    def paginate!
      @paras.each do |para|
        new_para= @pages.last.push_para(para)
        unless new_para.nil?
          new_paras= [new_para]
          if new_para.split_state == :whole
            while @pages.last.paras.last.keep_with_next? new_paras.first
              new_paras.unshift(@pages.last.paras.pop)
              if @pages.last.paras.empty?
                raise "pagination error: string of keep-with-nexts larger " \
                      "than one page; occured at:\n  #{para}"
              end
            end
          end
          new_page= Page.new(self, @pages.size + 1)
          new_paras.each do |p|
            new_page_para= new_page.push_para(p)
            if new_page_para
              raise "pagination error: string of keep-with-nexts larger than " \
                    "one page:\n  #{new_page_para}"
            end
          end
          first_para= new_page.paras.first
          if first_para.is_a?(CharacterCue) && first_para.split_state == :widow
            @pages.last.push_para(More.new(self), true)
          end
          @pages << new_page
        end
      end
      @pages
    end

    # Parses the plain text screenplay at +filename+.  Returns +nil+ if parsing
    # failed and an array of paragraphs if it succeeded.  The paras attribute
    # will be valid if parsing is successful.
    def parse! filename
      parse_! filename
    end

    # The screenplay's title, nil if none.
    def title
      @title_pages.each { |tp| tp.title and return tp.title }
      nil
    end

    def to_s paginated=true
      if paginated
        @pages.inject('') { |str, page| "#{str}#{page}" }
      else
        @paras.inject('') { |str, para| "#{str}#{para}\n" }
      end
    end

    private :parse_!

  end



  # A screenplay title page.
  class TitlePage < Page

    # See initialize
    attr_reader :author, :contact, :title

    # +options+ can include any title page elements recognized by the parser
    # and backend.  With the default parser and backend, options include
    # :author, :contact, and :title.  :author and :title are strings.  :contact
    # is an array of strings.  Each option is turned into an instance variable.
    def initialize options={}
      options.each_pair do |att_name, att_val|
        instance_variable_set("@#{att_name}", att_val)
      end
    end

  end

end
