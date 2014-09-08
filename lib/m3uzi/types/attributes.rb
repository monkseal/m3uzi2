module M3Uzi2
  # Simple container for the attributes.
  class Attributes < Hash
    def to_s
      map { | _k, v | v.to_s }.join(',')
    end

    # ==== Description
    # Takes a string of 1 or more comma seperated attribute=value pairs
    # and yields them to the given block.
    def self.parse(str)
      err_msg = 'Invalid Attribute/Value Pair: '
      if str.index(',').nil?
        fail err_msg << str unless str.index('=')
        yield str.split('=') if block_given?
      else
        str.split(',').each do | attr |
          fail err_msg << attr unless attr.index('=')
          yield attr.split('=') if block_given?
        end
      end
    end
  end

  # An attribute of a Tag which is a key/value pair seperated by an equals sign
  # e.g. BANDWIDTH=901122
  class Attribute
    attr_reader :parent_tag,
                :name

    attr_accessor :value

    def initialize(parent_tag, name, value = nil)
      @parent_tag = parent_tag
      @name = name
      @value = value
    end

    def parent_attribute(attr_name)
      parent_tag.attributes[attr_name]
    end

    def valid?
      @parent_tag.specification.check_attribute(self)
    end

    def to_s
      "#{name}=#{value}"
    end
  end
end
