module Suitcase
  class Room
    extend Hotel::Helpers
    attr_accessor :rate_key, :hotel_id, :supplier_type, :rate_code, :room_type_code, :supplier_type, :tax_rate, :non_refundable, :occupancy, :quoted_occupancy, :min_guest_age, :total, :surcharge_total, :nightly_rate_total, :average_base_rate, :average_rate, :max_nightly_rate, :currency_code, :value_adds, :room_type_description, :price_breakdown, :total_price, :average_nightly_rate, :promo, :arrival, :departure, :rooms, :bed_types

    def initialize(info)
      info.each do |k, v|
        instance_variable_set("@" + k.to_s, v)
      end
    end

    def reserve!(info)
      params = {}
      params["hotelId"] = @hotel_id
      params["arrivalDate"] = @arrival
      params["departureDate"] = @departure
      params["supplierType"] = @supplier_type
      params["rateKey"] = @rate_key
      params["rateTypeCode"] = @room_type_code
      params["rateCode"] = @rate_code
      params["roomTypeCode"] = @room_type_code
      params["chargeableRate"] = chargeable_rate      
      params["email"] = info[:email]
      params["firstName"] = info[:first_name]
      params["lastName"] = info[:last_name]
      params["homePhone"] = info[:home_phone]
      params["workPhone"] = info[:work_phone] if info[:work_phone]
      params["extension"] = info[:work_phone_extension] if info[:work_phone_extension]
      params["faxPhone"] = info[:fax_phone] if info[:fax_phone]
      params["companyName"] = info[:company_name] if info[:company_name]
      params["emailIntineraryList"] = info[:additional_emails].join(",") if info[:additional_emails]
      params["creditCardType"] = info[:payment_option].code
      params["creditCardNumber"] = info[:credit_card_number]
      params["creditCardIdentifier"] = info[:credit_card_verification_code]
      expiration_date = Date._parse(info[:credit_card_expiration_date])
      params["creditCardExpirationMonth"] = (expiration_date[:mon].to_s.length == 1 ? "0" + expiration_date[:mon].to_s : expiration_date[:mon].to_s)
      params["creditCardExpirationYear"] = expiration_date[:year].to_s
      params["address1"] = info[:address1]
      params["address2"] = info[:address2] if info[:address2]
      params["address3"] = info[:address3] if info[:address3]
      params["city"] = info[:city]
      @rooms.each_with_index do |room, index|
        index += 1
        params["room#{index}"] = "#{room[:adults].to_s},#{room[:children_ages].join(",")}"
        params["room#{index}FirstName"] = room[:first_name] || params["firstName"] # defaults to the billing
        params["room#{index}LastName"] = room[:last_name] || params["lastName"] # person's name
        params["room#{index}BedTypeId"] = room[:bed_type].id
        params["room#{index}SmokingPreference"] = room[:smoking_preference] or "E"
      end
      params["stateProvinceCode"] = info[:province]
      params["countryCode"] = info[:country]
      params["postalCode"] = info[:postal_code]
      uri = Room.url :method => "res", :params => params, :include_key => true, :include_cid => true, :secure => true
      session = Patron::Session.new
      session.base_url = "https://" + uri.host
      res = session.post uri.request_uri, {}
      parsed = JSON.parse res.body
      Reservation.new(itinerary_id: parsed["HotelRoomReservationResponse"]["itineraryId"], confirmation_numbers: parsed["HotelRoomReservationResponse"]["confirmationNumbers"])
    end

    def chargeable_rate
      if @supplier_type == "E"
        @total_price
      else
        @max_nightly_rate
      end
    end
  end
end
