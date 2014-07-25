module Poseidon
  module Compression
    module SnappyCodec
      def self.codec_id
        2
      end

      def self.compress(s)
        ensure_snappy! do
          with_buffer do |buffer|
            Snappy::Writer.new buffer do |w|
              w << s
            end
          end
        end
      end

      def self.decompress(s)
        ensure_snappy! do
          io = StringIO.new s
          io.set_encoding("ASCII-8BIT") 
          Snappy::Reader.new(io).read
        end
      end

      private

      def self.with_buffer
        buffer = StringIO.new
        buffer.set_encoding Encoding::ASCII_8BIT unless RUBY_VERSION =~ /^1\.8/
        yield buffer if block_given?
        buffer.rewind
        buffer.string
      end

      def self.ensure_snappy!
        if Object.const_defined? "Snappy"
          yield
        else
          fail "Snappy not available!"
        end
      end
    end
  end
end

