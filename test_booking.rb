require 'test/unit'

class BookingTests < Test::Unit::TestCase    
    def test_When_booking_one_night_in_double_room_at_palace_hotel_Then_displayed_total_is_79_pounds
        price_of_one_night_in_double_room_at_palace_hotel = Money.new(amount: 79)
        hotel_room_stay = HotelRoomStay.new(
            hotel: 'Palace Hotel', 
            room_type: 'Double Room',
            number_of_nights: 1
        )
        Booking.new(self, {hotel_room_stay.room_type => price_of_one_night_in_double_room_at_palace_hotel})
            .add(hotel_room_stay)
            .total
        assert_equal(price_of_one_night_in_double_room_at_palace_hotel, @displayed_total)
    end

    def test_When_booking_one_night_in_single_room_at_palace_hotel_Then_displayed_total_is_63_pounds
        price_of_one_night_in_single_room_at_palace_hotel = Money.new(amount: 63)
        hotel_room_stay = HotelRoomStay.new(
            hotel: 'Palace Hotel',
            room_type: 'Single Room',
            number_of_nights: 1
        )
        Booking.new(self, {hotel_room_stay.room_type => price_of_one_night_in_single_room_at_palace_hotel})
            .add(hotel_room_stay)
            .total
        assert_equal(price_of_one_night_in_single_room_at_palace_hotel, @displayed_total)
    end
    
    def show_total(total)
        @displayed_total = total
    end
end

class Booking
    def initialize(booking_display, room_prices)
        @booking_display = booking_display
        @room_prices = room_prices
    end
    
    def add(hotel_room_stay)
        @total = @room_prices[hotel_room_stay.room_type] 
        self
    end
    def total
        @booking_display.show_total(@total)
    end
end

class Money
    attr_reader :amount

    def initialize(values)
        @amount = values[:amount]
    end

    def ==(money)
        @amount == money.amount
    end
end

class HotelRoomStay
    attr_reader :hotel, :room_type, :number_of_nights
    
    def initialize(values)
        @hotel = values[:hotel]
        @room_type = values[:room_type]
        @number_of_nights =values[:number_of_nights]
    end
end