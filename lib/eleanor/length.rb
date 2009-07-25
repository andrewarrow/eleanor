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
# See Length class.

# A handy way to pass around lengths of various units and mix and match them
# regardless of unit.  Could be a little more robust but works well enough.
#
# Units are defined by adding entries to the UNITS hash.  That's it.  By way of
# some metaprogramming, each entry in the hash creates a new subclass of
# Length that shares the name of the entry's key.  So, currently there are
# three Length subclasses: Inches, Lines, and Points.
#
# Length.line_height must be set before anything is done with any Lengths.  Set
# it to a value in points:
#
#   Length.line_height= 12   # OK, now go for it
#
# New Length subclass instances can be created in three ways:
#
# * Constructors: Points.new(32)
# * Length conversion instance methods: Inches.new(0.5).to_points
# * Numeric instance methods: 32.points
#
# To get at the raw Numeric that Lengths encapsulate, use to_i or to_f:
#
#   1.5.inches.to_i   # => 1
#   1.5.inches.to_f   # => 1.5
#
# All the operations that apply to Numerics can be applied to Lengths, too:
#
#   1.inches + 12.lines     # => #<Inches:0x7fed2694 @val=3.0>
#   12.lines + 1.inches     # => #<Lines:0x7fece364 @val=18.0>
#   2.points * 100          # => #<Points:0x7feca278 @val=200.0>
#   72.points == 1.inches   # => true
#   72.points == 1          # error!
#
# More examples:
#
#   Length.line_height= 12    # => 12
#   Inches.new(1)             # => #<Inches:0x7ff37120 @val=1.0>
#   Inches.new(1).to_points   # => #<Points:0x7ff01ebc @val=72.0>
#   6.lines                   # => #<Lines:0x7fefde48 @val=6.0> 
#   6.lines.to_points.to_f    # => 72
#   6.lines + 0.5.inches      # => #<Lines:0x7fef44ec @val=9.0>
#   Inches.new(72.points)     # => #<Inches:0x7ff95ae0 @val=1.0>

class Length

  # All units are defined in terms of points.
  UNITS= {
    :Inches => { :points => 72.0, :abbrev => 'in' },
    :Lines  => { :points => nil,  :abbrev => 'ln' },
    :Points => { :points => 1.0,  :abbrev => 'pt' }
  }

  include Comparable

  # This is filled in once line_height is set.  Maps the abbreviations in
  # the UNITS hash to their corresponding Length subclasses, e.g.,
  # 'in' => Inches.
  ABBREVIATIONS= {}

  # Sets the line height to +points+.  Since calling this kicks off the
  # metaprogramming that builds the Length subclasses, line height must be set
  # before anything else is done.
  def self.line_height= points
    UNITS[:Lines][:points]= points
    UNITS.each_pair do |this_unit, this_meta|
      # create new class this_unit
      klass= Class.new(self)
      # class gets to_<length> methods for each class of length
      klass.class_eval do
        UNITS.each_pair do |unit, meta|
          define_method("to_#{unit.to_s.downcase}") do
            points= (@val * this_meta[:points]) / meta[:points]
            Object.const_get(unit).new(points)
          end
        end
      end
      Object.const_set(this_unit, klass)
      # add entry to abbreviations table
      ABBREVIATIONS[this_meta[:abbrev]]= klass
      # add <this_unit> method to Numeric
      Numeric.class_eval do
        define_method(this_unit.to_s.downcase) { klass.new(self) }
      end
    end
  end

  # Returns the line height.
  def self.line_height
    UNITS[:Lines][:points]
  end

  # If +str+ represents a Length, returns it.  Returns nil otherwise.  Strings
  # that represent Lengths end in a Length abbreviation, e.g., "32in", "-1.72pt".
  def self.parse str
    match= /[a-zA-Z]+$/.match(str)
    if match.nil? || !ABBREVIATIONS.has_key?(match[0])
      nil
    else
      ABBREVIATIONS[match[0]].new(str[0..-(match[0].length + 1)].to_f)
    end
  end

  # +obj+ must be a Length.
  def <=> obj
    if obj.is_a? Length
      @val <=> obj.send("to_#{self.class.name.downcase}").to_f
    else
      raise TypeError, "#{self.class} is incomparable to #{obj.class}"
    end
  end

  # +val+ may be a Numeric, a String that can be coerced into a Numeric, or
  # a Length.
  def initialize val
    @val=
      case val
      when Numeric, String
        val.to_f
      when Length
        val.send("to_#{self.class.name.downcase}").to_f
      else
        raise TypeError, "cannot initialize #{self.class} from #{val.class}"
      end
  end

  def to_i
    @val.to_i
  end

  def to_f
    @val
  end

  def to_s
    "#{@val.to_s} #{self.class.name.downcase}"
  end

  private

  def method_missing meth, *args
    if @val.respond_to? meth
      args= args.map { |a| a.is_a?(Length) ? self.class.new(a).to_f : a }
      self.class.new(@val.send(meth, *args))
    else
      super(meth, args)
    end
  end

end
