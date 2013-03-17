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
        @booking_total = BookingTotal.new(booking_display)
        @hotel = Hotel.new(room_prices, @booking_total)
    end
    
    def add(hotel_room_stay)
        hotel_booking = HotelBooking.new(room_type: hotel_room_stay.room_type)
        @hotel.book_room(hotel_booking)
        self
    end

    def total
        @booking_total.show
    end
end

class HotelBooking
    attr_reader :room_type

    def initialize(values)
        @room_type = values[:room_type]
    end
end

class Hotel
    def initialize(room_prices, booking_total)
        @room_prices = room_prices
        @booking_total = booking_total
    end

    def book_room(hotel_booking)
        room_price = @room_prices[hotel_booking.room_type] 
        @booking_total.increment_by(room_price)
    end
end

class BookingTotal
    def initialize(booking_display)
        @booking_display = booking_display
    end

    def increment_by(amount)
        @total_amount = amount
    end

    def show
        @booking_display.show_total(@total_amount)
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