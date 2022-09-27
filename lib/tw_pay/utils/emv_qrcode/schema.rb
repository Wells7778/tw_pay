module TwPay
  module Utils
    module EmvQrcode
      module Schema
        DataObjectType = Struct.new(:id, :name, keyword_init: true) do
          def primitive?
            true
          end
        end

        TemplateType = Struct.new(:id, :name, :data_object_types, keyword_init: true) do
          def primitive?
            false
          end
        end

        class AdditionalDataFieldType < TemplateType
          def initialize
            data_object_types = [
              DataObjectType.new(id: '01', name: :bill_number),
              DataObjectType.new(id: '02', name: :mobile_number),
              DataObjectType.new(id: '03', name: :store_label),
              DataObjectType.new(id: '04', name: :loyalty_number),
              DataObjectType.new(id: '05', name: :reference_label),
              DataObjectType.new(id: '06', name: :customer_label),
              DataObjectType.new(id: '07', name: :terminal_label),
              DataObjectType.new(id: '08', name: :transaction_purpose)
            ]

            ('09'..'99').each do |id|
              data_object_types << DataObjectType.new(id: id, name: :"reserved_#{id}")
            end

            super(
              id: '62',
              name: :additional_data_field,
              data_object_types: data_object_types
            )
          end
        end

        class TwPayPaymentInfo < TemplateType
          def initialize(data_id)
            data_object_types = [
              DataObjectType.new(id: '00', name: :identifier),
              DataObjectType.new(id: '01', name: :merchant_info),
            ]
            super(
              id: data_id,
              name: :tw_payment_info,
              data_object_types: data_object_types
            )
          end
        end

        class LanguageTemplate < TemplateType
          def initialize
            data_object_types = [
              DataObjectType.new(id: '00', name: :language_preference),
              DataObjectType.new(id: '01', name: :merchant_name),
              DataObjectType.new(id: '02', name: :merchant_city),
            ]

            ('03'..'99').each do |id|
              data_object_types << DataObjectType.new(id: id, name: :"reserved_#{id}")
            end

            super(
              id: '64',
              name: :language_template,
              data_object_types: data_object_types
            )
          end
        end

        class TwPayInteractionInfo < TemplateType
          def initialize(data_id)
            data_object_types = [
              DataObjectType.new(id: '00', name: :identifier),
            ]

            ('01'..'04').each do |id|
              data_object_types << DataObjectType.new(id: id, name: :"reserved_#{id}")
            end

            super(
              id: data_id,
              name: :interaction_info,
              data_object_types: data_object_types
            )
          end
        end

        class TwPayInteractionInfoExtra < TemplateType
          def initialize(data_id)
            data_object_types = [
              DataObjectType.new(id: '00', name: :identifier),
            ]

            ('01'..'02').each do |id|
              data_object_types << DataObjectType.new(id: id, name: :"reserved_#{id}")
            end

            super(
              id: data_id,
              name: :interaction_info_extra,
              data_object_types: data_object_types
            )
          end
        end

        ADDITIONAL_DATA_FIELD = AdditionalDataFieldType.new
        LANGUAGE_TEMPLATE = LanguageTemplate.new

        DATA_OBJECT_TYPES = [
          DataObjectType.new(id: "00", name: :payload_format_indicator),
          DataObjectType.new(id: "01", name: :point_of_initiation_method),
          TwPayPaymentInfo.new('35'),
          TwPayPaymentInfo.new('36'),
          TwPayPaymentInfo.new('37'),
          TwPayPaymentInfo.new('38'),
          TwPayPaymentInfo.new('39'),
          TwPayPaymentInfo.new('40'),
          DataObjectType.new(id: '52', name: :merchant_category_code),
          DataObjectType.new(id: '53', name: :transaction_currency),
          DataObjectType.new(id: '54', name: :transaction_amount),
          DataObjectType.new(id: '55', name: :tip_or_convenience_fee_indicator),
          DataObjectType.new(id: '56', name: :value_of_convenience_fee_fixed),
          DataObjectType.new(id: '57', name: :value_of_convenience_fee_percentage),
          DataObjectType.new(id: '58', name: :country_code),
          DataObjectType.new(id: '59', name: :merchant_name),
          DataObjectType.new(id: '60', name: :merchant_city),
          DataObjectType.new(id: '61', name: :postal_code),
          ADDITIONAL_DATA_FIELD,
          LANGUAGE_TEMPLATE,
          TwPayInteractionInfo.new('80'),
          TwPayInteractionInfo.new('81'),
          TwPayInteractionInfo.new('82'),
          TwPayInteractionInfo.new('83'),
          TwPayInteractionInfo.new('84'),
          TwPayInteractionInfo.new('85'),
          TwPayInteractionInfoExtra.new('86'),
          TwPayInteractionInfoExtra.new('87'),
          TwPayInteractionInfoExtra.new('88'),
          TwPayInteractionInfoExtra.new('89'),
          TwPayInteractionInfoExtra.new('90'),
        ]

        ("00".."99").each do |id|
          next if DATA_OBJECT_TYPES.any? { |d| d.id == id }

          DATA_OBJECT_TYPES << DataObjectType.new(id: id, name: :"reserved_#{id}")
        end

        def self.data_object_types
          DATA_OBJECT_TYPES
        end
      end
    end
  end
end