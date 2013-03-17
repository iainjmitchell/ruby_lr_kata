require 'test/unit'

class BookingTests < Test::Unit::TestCase    
    def test_When_booking_one_night_in_double_room_at_palace_hotel_Then_displayed_total_is_79_pounds
        price_of_one_night_in_double_room_at_palace_hotel = Money.new(amount: 79)
        hotel_room_stay = HotelRoomStay.new(
            hotel: 'Palace Hotel', 
            room_type: 'Double Room',
            number_of_nights: 1
        )
        Booking.new(self, price_of_one_night_in_double_room_at_palace_hotel)
            .add(hotel_room_stay)
            .total
        assert_equal(price_of_one_night_in_double_room_at_palace_hotel, @displayed_total)
    end
    
    def show_total(total)
        @displayed_total = total
    end
end

class Booking
    def initialize(booking_display, price_of_one_night_in_double_room_at_palace_hotel)
        @booking_display = booking_display
        @price_of_one_night_in_double_room_at_palace_hotel = price_of_one_night_in_double_room_at_palace_hotel
    end
    
    def add(hotel_room_stay)
        self
    end
    def total
        @booking_display.show_total(@price_of_one_night_in_double_room_at_palace_hotel)
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