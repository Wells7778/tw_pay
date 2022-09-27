require_relative './schema.rb'

module TwPay
  module Utils
    module EmvQrcode
      class Decoder
        def initialize(qrcode)
          @raw_qrcode = qrcode
        end

        def decode
          @data = decode_data_objects @raw_qrcode, Schema
        end

        def get(name, sub_name = nil)
          return @data.dig name.to_sym, :value, sub_name.to_sym, :value if sub_name

          @data.dig name.to_sym, :value
        end

        private

        def decode_data_objects(raw_data, template)
          result = {}
          each_data_object(raw_data) do |data_object_id, value|
            data_object_type = find_data_object_type data_object_id, template
            next if data_object_type.nil?

            value = decode_data_objects(value, data_object_type) unless data_object_type.primitive?
            result[data_object_type.name] ||= {}
            result[data_object_type.name][:id] = data_object_id
            result[data_object_type.name][:value] = value
          end

          result
        end

        def each_data_object(raw_data)
          scanner = StringScanner.new raw_data
          until scanner.eos?
            data_object_id = scanner.scan(/\d{2}/)
            value_length = scanner.scan(/\d{2}/).to_i
            value = scanner.scan(/.{#{value_length}}/)

            yield data_object_id, value
          end
        end

        def find_data_object_type(id, template)
          template.data_object_types.find { |type| type.id == id }
        end
      end
    end
  end
end