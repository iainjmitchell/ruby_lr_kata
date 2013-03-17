class Money
    attr_reader :amount

    def initialize(values)
        @amount = values[:amount]
    end

    def ==(money)
        @amount == money.amount
    end
end