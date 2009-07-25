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
#
# ---
#
# This is Eleanor's backend.  Eleanor uses a paper metaphor to talk to the
# backend: after parsing and pagination, Eleanor "writes" the screenplay to
# "paper," which by default is PDF.  But you could write a backend to target
# anything, like XML, XSL-FO, Postscript, RTF, the screen, a socket, whatever.
# Depending on the capabilities of the paper, a backend may choose to ignore
# some of the user's configuration options, like font, line height, and character
# spacing.
#
# Eleanor's interface with the backend is really simple, allowing wide latitude
# in how it's implemented.  No special modules or classes are needed.  Just add
# five instance methods to the Screenplay class, and Eleanor will call them when
# appropriate.  (You'll probably end up adding other methods to other classes in
# your implementation, too.)
#
# [initialize_paper!]
#   Called when the screenplay is initialized.  Can be used to setup any
#   instance variables needed by the backend.
# [line_height]
#   Called when calculating the height of a paragraph.  Returns a Length.  If the
#   paper supports custom line heights, this method should make use of
#   Screenplay#line_height_points, which returns the value specified in the
#   user's configuration YAML.
# [save_paper(out_filename, in_filename=nil)]
#   Writes out the paper representation to +out_filename+.  If +out_filename+ is
#   nil, the method may use +in_filename+ to generate an output filename.  For
#   example, if +in_filename+ is "screenplay.txt", the method might return
#   "screenplay.pdf".
# [text_width(str)]
#   Returns the width (a Length) of +str+ in the current font size and character
#   spacing.  If the paper supports custom font sizes and character spacing,
#   this method should make use of Screenplay#font_size and
#   Screenplay#char_spacing, which return the values specified in the user's
#   configuration YAML.
# [write_to_paper!]
#   Called after parsing and pagination.  Translates the screenplay to the paper
#   representation.
#
# This implementation uses libHaru[http://libharu.org/], a free and open-source
# PDF library written in ANSI C that comes with Ruby bindings.  It allows text
# underlining by surrounding bits of text in underscores:
#
#   You can underline a single _word_, or _many words at once._

require 'hpdf'

# Some handy, high-level methods for libHaru's HPDFPage class.
class HPDFPage

  alias :begin_text_ :begin_text
  alias :end_text_   :end_text
  alias :text_width_ :text_width

  # Overridden to implement underlining.
  def begin_text
    self.begin_text_
    @underline_coords= []
  end

  # Overridden to implement underlining.
  def end_text
    self.end_text_
    @underline_coords.each do |pair|
      self.move_to(pair[0][0], pair[0][1])
      self.line_to(pair[1][0], pair[1][1])
      self.stroke
    end
  end

  # Writes a line, +str+, to the page and moves the text pointer down the page
  # by +line_height_pts+ points.  Any text surrounded by underscores is
  # underlined.
  def line str, line_height_pts
    unless str.nil? || str.empty?
      pos= self.get_current_text_pos
      # implement underlining: split the line on "_" => every other segment is a
      # string of text that should be underlined.
      segs= str.split(/_/)
      segs.each_with_index do |seg, si|
        if si % 2 == 1
          y= pos[1] - 1 # draw underline one point below line
          coord1= [pos[0] + self.text_width(segs[0..(si - 1)].join), y]
          coord2= [coord1[0] + self.text_width(seg), y]
          @underline_coords << [coord1, coord2]
        end
      end
      # finally, print the line
      self.show_text(segs.join)
    end
    self.move_text_pos(0, -line_height_pts)
  end

  # Writes a centered line at the current vertical position.  See line.
  def line_center str, line_height_pts
    self.move_text_pos(-self.get_current_text_pos[0] +
                       (self.get_width / 2.0) -
                       (self.text_width(str) / 2.0),
                       0)
    self.line(str, line_height_pts)
  end

  # Writes a line flushed to the right margin, which is specified by
  # +margin_right+, a Length, at the current vertical position.  See line.
  def line_flush_right str, line_height_pts, margin_right
    self.move_text_pos(-self.get_current_text_pos[0] +
                       self.get_width -
                       (margin_right.to_points.to_f) -
                       self.text_width(str),
                       0)
    self.line(str, line_height_pts)
  end

  # Moves the text pointer horizontally to the given margin +length+.
  def margin_left= length
    self.move_text_pos(-self.get_current_text_pos[0] + length.to_points.to_f, 0)
  end

  # Moves the text pointer down the page by +length+.
  def move_down length
    self.move_text_pos(0, -length.to_points.to_f)
  end

  # Moves the text pointer to the very first line on the page.
  def move_to_top
    # + 3 because without it, there's a little gap at the top
    self.move_text_pos(0,
                       -self.get_current_text_pos[1] +
                       self.get_height -
                       self.get_current_font_size + 3)
  end

  # Overridden to implement underlining.
  def text_width str
    self.text_width_(str.gsub(/_/, ''))
  end

end



module Eleanor

  class Page

    # An implementation detail in the backend.  See lib/eleanor/hpdfpaper.rb.
    def write_to_paper pdf_page, line_height_pts
      pdf_page.begin_text
      # header
      if self.header
        pdf_page.move_to_top
        pdf_page.move_down(self.header_margin_top)
        pdf_page.line_center(self.header, line_height_pts)
      end
      # page number
      if self.page_number_display
        pdf_page.move_to_top
        pdf_page.move_down(self.page_number_margin_top)
        pdf_page.line_flush_right(self.page_number_display,
                                  line_height_pts,
                                  self.page_number_margin_right)
      end
      # finally, paragraphs
      pdf_page.move_to_top
      pdf_page.move_down(self.margin_top_actual)
      prev_para= nil
      @paras.each do |para|
        pdf_page.move_down(prev_para.margin_between(para)) if prev_para
        para.write_to_paper(pdf_page, line_height_pts)
        prev_para= para
      end
      pdf_page.end_text
    end

  end



  class Paragraph

    # An implementation detail in the backend.  See lib/eleanor/hpdfpaper.rb.
    def write_to_paper pdf_page, line_height_pts
      underline_broken= false
      @lines.each do |line|
        if underline_broken
          line= '_' + line
          underline_broken= false
        end
        if line.count('_') % 2 == 1
          line << '_'
          underline_broken= true
        end
        case self.align.to_s.strip.downcase
        when 'left'
          pdf_page.margin_left= self.margin_left
          pdf_page.line(line, line_height_pts)
        when 'center'
          pdf_page.line_center(line, line_height_pts)
        when 'right'
          pdf_page.line_flush_right(line, line_height_pts, self.margin_right)
        else
          raise "configuration error: invalid align value " \
                "#{self.align.inspect} for #{self.class}"
        end
      end
      if underline_broken
        warn "warning: runaway underline at paragraph:\n  #{self}"
      end
    end

  end



  class Screenplay

    # A required method in the backend.  See lib/eleanor/hpdfpaper.rb.
    def initialize_paper!
      @pdf= HPDFDoc.new
      font_name= (%r{[\./\\]} =~ self.font ?
                  @pdf.load_ttfont_from_file(self.font, HPDFDoc::HPDF_TRUE) :
                  self.font)
      @pdf_font= @pdf.get_font(font_name, nil)
      @first_pdf_page= add_pdf_page(@pages.first)
    end

    # A required method in the backend.  See lib/eleanor/hpdfpaper.rb.
    def line_height
      self.line_height_points.points
    end

    # A required method in the backend.  See lib/eleanor/hpdfpaper.rb.
    def save_paper out_filename, in_filename=nil
      out_filename ||= (File.join(File.dirname(in_filename),
                                  File.basename(in_filename,
                                                File.extname(in_filename))) +
                        '.pdf')
      @pdf.save_to_file(out_filename)
    end

    # A required method in the backend.  See lib/eleanor/hpdfpaper.rb.
    def text_width str
      @first_pdf_page.text_width(str).points
    end

    # A required method in the backend.  See lib/eleanor/hpdfpaper.rb.
    def write_to_paper!
      if self.title
        @pdf.set_info_attr(HPDFDoc::HPDF_INFO_TITLE, self.title.gsub(/_/, ''))
      end
      @pdf.set_info_attr(HPDFDoc::HPDF_INFO_AUTHOR, self.author) if self.author
      @pdf.set_info_attr(HPDFDoc::HPDF_INFO_CREATOR,
                         "#{Eleanor::NAME} #{Eleanor::VERSION}")
      @title_pages.each do |page|
        pdf_page= add_pdf_page(page, @first_pdf_page)
        page.write_to_paper(pdf_page, self.line_height_points)
      end
      @pages.each_with_index do |page, i|
        pdf_page= (i == 0 ? @first_pdf_page : add_pdf_page(page))
        page.write_to_paper(pdf_page, self.line_height_points)
      end
    end

    private

    def add_pdf_page eleanor_page, before_pdf_page=nil
      pdf_page= (before_pdf_page.nil??
                 @pdf.add_page :
                 @pdf.insert_page(before_pdf_page))
      pdf_page.set_width(eleanor_page.width.to_points.to_f)
      pdf_page.set_height(eleanor_page.height.to_points.to_f)
      pdf_page.set_line_width(0.75) # underline stroke width
      pdf_page.set_font_and_size(@pdf_font, self.font_size.to_points.to_f)
      pdf_page.set_char_space(self.char_spacing.to_points.to_f)
      pdf_page
    end

  end



  class TitlePage

    # An implementation detail in the backend.  See lib/eleanor/hpdfpaper.rb.
    def write_to_paper pdf_page, line_height_pts
      pdf_page.begin_text
      pdf_page.move_to_top
      pdf_page.move_down(self.margin_top)
      pdf_page.line_center(@title, line_height_pts) unless @title.nil?
      pdf_page.move_down(1.lines)
      unless @by.nil?
        pdf_page.line_center(@by, line_height_pts)
        pdf_page.move_down(1.lines)
      end
      pdf_page.line_center(@author, line_height_pts) unless @author.nil?
      unless @contact.nil?
        pdf_page.move_to_top
        pdf_page.move_down(self.height -
                           (@contact.size * line_height_pts).points -
                           self.margin_bottom)
        pdf_page.margin_left= self.margin_left
        @contact.each { |line| pdf_page.line(line, line_height_pts) }
      end
      pdf_page.end_text
    end
  end

end
