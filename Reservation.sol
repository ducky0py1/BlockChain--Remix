// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Reservation {

    address public owner;
    uint public reservationPrice = 0.1 ether;

    struct Booking {
        address user;
        string name;
        uint date;
        uint amount;
        bool cancelled;
    }

    Booking[] public bookings;

    constructor() {
        owner = msg.sender;
    }

    // Make a reservation
    function reserve(string memory _name, uint _date) public payable {
        require(msg.value >= reservationPrice, "Not enough ETH");

        bookings.push(Booking({
            user: msg.sender,
            name: _name,
            date: _date,
            amount: msg.value,
            cancelled: false
        }));
    }

    // Get number of bookings
    function getBookingsCount() public view returns (uint) {
        return bookings.length;
    }

    // Cancel reservation (refund)
    function cancelReservation(uint index) public {
        Booking storage booking = bookings[index];

        require(msg.sender == booking.user, "Not your reservation");
        require(!booking.cancelled, "Already cancelled");

        booking.cancelled = true;

        payable(msg.sender).transfer(booking.amount);
    }

    // Withdraw all funds (owner only)
    function withdraw() public {
        require(msg.sender == owner, "Not owner");

        payable(owner).transfer(address(this).balance);
    }
}