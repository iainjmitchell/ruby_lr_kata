require 'test/unit'
require './src/Money'

class BookingTests < Test::Unit::TestCase 
    PRICE_OF_ONE_NIGHT_IN_DOUBLE_ROOM_AT_PALACE_HOTEL = Money.new(amount: 79)
    PRICE_OF_ONE_NIGHT_IN_SINGLE_ROOM_AT_PALACE_HOTEL = Money.new(amount: 63)

    def test_When_booking_one_night_in_double_room_at_palace_hotel_Then_displayed_total_matches_room_price
        hotel_room_stay = HotelRoomStay.new(
            hotel: 'Palace Hotel', 
            room_type: 'Double Room',
            number_of_nights: 1
        )
        room_type_price_repository = FakeRoomTypePriceRepository.new(
            {hotel_room_stay.room_type => PRICE_OF_ONE_NIGHT_IN_DOUBLE_ROOM_AT_PALACE_HOTEL})
        Booking.new(self, room_type_price_repository)
            .add(hotel_room_stay)
            .total
        assert_equal(PRICE_OF_ONE_NIGHT_IN_DOUBLE_ROOM_AT_PALACE_HOTEL, @displayed_total)
    end

    def test_When_booking_one_night_in_single_room_at_palace_hotel_Then_displayed_total_matches_room_price
        hotel_room_stay = HotelRoomStay.new(
            hotel: 'Palace Hotel',
            room_type: 'Single Room',
            number_of_nights: 1
        )
        room_type_price_repository = FakeRoomTypePriceRepository.new(
            {hotel_room_stay.room_type => PRICE_OF_ONE_NIGHT_IN_SINGLE_ROOM_AT_PALACE_HOTEL})
        Booking.new(self, room_type_price_repository)
            .add(hotel_room_stay)
            .total
        assert_equal(PRICE_OF_ONE_NIGHT_IN_SINGLE_ROOM_AT_PALACE_HOTEL, @displayed_total)
    end

    def test_When_booking_two_nights_in_single_room_at_palace_hotel_Then_displayed_total_is_double_room_price
        hotel_room_stay = HotelRoomStay.new(
            hotel: 'Palace Hotel',
            room_type: 'Single Room',
            number_of_nights: 2
        )
        expected_total_amount = PRICE_OF_ONE_NIGHT_IN_SINGLE_ROOM_AT_PALACE_HOTEL.amount * hotel_room_stay.number_of_nights
        room_type_price_repository = FakeRoomTypePriceRepository.new(
            {hotel_room_stay.room_type => PRICE_OF_ONE_NIGHT_IN_SINGLE_ROOM_AT_PALACE_HOTEL})
        Booking.new(self, room_type_price_repository)
            .add(hotel_room_stay)
            .total
        assert_equal(Money.new(amount: expected_total_amount), @displayed_total)
    end

    def test_When_booking_one_night_in_single_and_double_room_at_palace_hotel_Then_displayed_total_is_room_prices_combined
        single_room_stay = HotelRoomStay.new(
            hotel: 'Palace Hotel',
            room_type: 'Single Room',
            number_of_nights: 1
        )
        double_room_stay = HotelRoomStay.new(
            hotel: 'Palace Hotel', 
            room_type: 'Double Room',
            number_of_nights: 1
        )
        room_prices_combined = PRICE_OF_ONE_NIGHT_IN_SINGLE_ROOM_AT_PALACE_HOTEL.amount + PRICE_OF_ONE_NIGHT_IN_DOUBLE_ROOM_AT_PALACE_HOTEL.amount
        room_type_price_repository = FakeRoomTypePriceRepository.new({
            single_room_stay.room_type => PRICE_OF_ONE_NIGHT_IN_SINGLE_ROOM_AT_PALACE_HOTEL,
            double_room_stay.room_type => PRICE_OF_ONE_NIGHT_IN_DOUBLE_ROOM_AT_PALACE_HOTEL
            })
        Booking.new(self, room_type_price_repository)
            .add(single_room_stay)
            .add(double_room_stay)
            .total

        assert_equal(Money.new(amount: room_prices_combined), @displayed_total)
    end
    
    def show_total(total)
        @displayed_total = total
    end
end

class FakeRoomTypePriceRepository
    def initialize(room_prices)
        @room_prices = room_prices
    end

    def get(room_type)
        @room_prices[room_type]
    end
end

class Booking
    def initialize(booking_display, room_type_price_repository)
        @booking_total = BookingTotal.new(booking_display)
        @hotel = Hotel.new(@booking_total, room_type_price_repository)
    end
    
    def add(hotel_room_stay)
        hotel_booking = HotelBooking.new(
            room_type: hotel_room_stay.room_type, 
            number_of_nights: hotel_room_stay.number_of_nights
        )
        @hotel.book_room(hotel_booking) 
        self
    end

    def total
        @booking_total.show
    end
end

class HotelBooking
    attr_reader :room_type, :number_of_nights

    def initialize(values)
        @room_type = values[:room_type]
        @number_of_nights = values[:number_of_nights]
    end
end

class Hotel
    def initialize(booking_total, room_type_price_repository)
        @booking_total = booking_total
        @room_type_price_repository = room_type_price_repository
    end

    def book_room(hotel_booking)
        room_price = @room_type_price_repository.get(hotel_booking.room_type)
        hotel_booking.number_of_nights.times do
            @booking_total.increment_by(room_price)
        end
    end
end

class BookingTotal
    def initialize(booking_display)
        @booking_display = booking_display
        @total_amount = 0
    end

    def increment_by(money)
        @total_amount += money.amount
    end

    def show
        @booking_display.show_total(Money.new(amount: @total_amount))
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