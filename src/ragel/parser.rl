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
# This is Eleanor's parser.  Its job is to define the private Screenplay#parse_!
# method, which takes the name of a plain text screenplay file.
#
# This implementation uses Ragel[http://research.cs.queensu.ca/~thurston/ragel/],
# a state machine compiler.  Run it through Ragel with:
#
#   ragel -R -o lib/eleanor/parser.rb src/ragel/parser.rl

=begin
# This is commented out so rdoc doesn't barf.  Ragel doesn't mind.

%%{

  machine parser;

  char      = any - space ;
  hspace    = [ \t] ;
  schar     = char | hspace ;
  nline     = '\r\n' | '\n' ;
  trailer   = hspace* nline ;

  aktion          = (char schar* nline trailer)
                    @{ classes= [Action]; consume= true }
                    @err{ error.call('Action') };

  character_cue   = hspace+ schar+ nline
                    @{ classes << CharacterCue }
                    @err{ error.call('Action') };

  dialog          = (hspace+ (char - '(') schar* nline)
                    @{ classes << Dialog }
                    @err{ error.call('Dialog') };

  insert          = (hspace+ schar+ nline trailer)
                    @{ classes= [Insert]; consume= true }
                    @err{ error.call('Insert') };

  montage_item    = ([A-Z] ') ' schar* nline trailer)
                    @{ classes= [MontageItem]; consume= true }
                    @err{ error.call('MontageItem') };

  montage_heading = (('MONTAGE' | 'SERIES OF SHOTS') schar* nline trailer)
                    @{ classes= [MontageHeading]; consume= true }
                    @err{ error.call('MontageHeading') };

  parenthetical   = (hspace+ '(' schar+ ')' trailer)
                    @{ classes << Parenthetical }
                    @err{ error.call('Parenthetical') };

  scene_heading   = (char schar* nline trailer)
                    @{ classes= [SceneHeading]; consume= true }
                    @err{ error.call('SceneHeading') };

  slug_line       = ([A-Z] [A-Z0-9!-/:-@[-`{-~ ]* trailer trailer)
                    @{ classes= [SlugLine]; consume= true }
                    @err{ error.call('SlugLine') };

  transition      = (hspace+ [A-Z] ([A-Z ]* [A-Z])? [:.] trailer trailer)
                    @{ classes= [Transition]; consume= true }
                    @err{ error.call('Transition') };

  tp_line         = hspace+ char schar* nline ;

  title_page      = (tp_line (tp_line tp_line*)? trailer+)
                    @{ classes= [TitlePage]; consume= true }
                    @err{ error.call('TitlePage') };

  character = (character_cue (dialog | (dialog? (parenthetical dialog)+))
               trailer)
              >{ classes= [] }
              @{ consume= true } ;

  montage   = montage_heading montage_item+ transition? trailer+ ;

  scene     = scene_heading aktion (aktion | character | slug_line | insert)*
              transition? trailer+ ;

  main := trailer* title_page* (transition trailer*)? (scene | montage)* ;

  write data;

}%%
=end

module Eleanor

  class Screenplay

    def parse_! filename
      lines= []
      last_char_cue= nil
      classes= nil
      # these are needed by ragel
      data= ''
      eof= nil
      %% write data;
      %% write init;
      File.open(filename, 'r') do |file|
        file.each_line do |line|
          line << "\n" * 3 if file.eof?
          error= lambda do |expected|
            warn "#{filename}:#{file.lineno}: parse error: expected #{expected}:"
            warn "  #{@paras[-2]}" if @paras.length >= 2
            warn "  #{@paras[-1]}" if @paras.length >= 1
            warn "  #{line.inspect}"
          end
          consume= false
          # these are needed by ragel
          data= line
          p= 0
          pe= data.length
          %% write exec;
          # collect lines until consume is set, i.e., we've seen a full
          # paragraph, in which case classes is non-nil
          lines << line
          if consume
            lines= lines.map { |l| l.strip }.reject { |l| l.empty? }
            unless lines.empty?
              if classes[0] == TitlePage
                @title_pages << TitlePage.new(:title   => lines[0],
                                              :author  => lines[1],
                                              :contact => lines[2..-1])
              else
                lines.each_with_index do |line, i|
                  @paras << classes[i].new(self, line, last_char_cue)
                  # remember the last character cue in the current scene
                  if classes[i] == CharacterCue
                    last_char_cue= @paras.last
                  elsif classes[i] == SceneHeading
                    last_char_cue= nil
                  end
                end
              end
            end
            lines= []
          end
        end
      end
      cs < parser_first_final ? nil : @paras
    end

  end

end
