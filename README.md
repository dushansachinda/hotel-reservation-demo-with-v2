# Building Cloud Native Applications: Hotel Reservation System

## Overview

This tutorial will walk you through the creation of a cloud-native hotel reservation system, which includes:

1. A Hotel Reservation Service developed using Java Spring Boot, Python, and Ballerina.
2. A Hotel Reservation Web Application developed using ReactJS.

## Prerequisites

Before you start, make sure you have:

- A GitHub account (forking instructions will be provided).
- Git installed on your workstation.
- A recent version of Google Chrome or Mozilla Firefox.
- Ballerina v2201.8.4 installed on your workstation.
- Microsoft Visual Studio (VSCode) with the WSO2 Ballerina plugin.
- Postman and curl (or any HTTP client) installed on your workstation.
- Azure communication service keys (we will help with connection strings and keys).
- A Choreo account.

## Business Scenario

The goal is to build a reservation system for a luxury hotel that allows users to search for rooms, make reservations, and manage their bookings.

## High-Level Steps

1. Develop the HTTP service using Spring Boot, Python services for email communication, and Ballerina for BFF services implementation using GraphQL.
2. Push the code to your GitHub account.
3. Deploy the cloud-native application on Choreo, including both services and the web application.

## Detailed Steps

### 1. Develop the GraphQL Service for Rooms Search Catalog (Experience API)

- Implement Ballerina GraphQL for the room search catalog.

### 2. Develop Java Spring Boot HTTP Service (Domain APIs)

Develop an HTTP service with Java Spring Boot that includes endpoints for:

- **Making reservations**: Handle POST requests with user data and return a confirmation with a unique reference number.
- **Listing reservations**: Allow users to retrieve their booking details.
- **Updating reservations**: Enable modifications to existing bookings.
- **Canceling reservations**: Provide a way for users to cancel their bookings.

### 3.Develop Python HTTP for Email Notification  (Domain APIs)
- The Python service will be designed to send email notifications related to user reservation activities. This service will interact with Azure communication services to manage the dispatch of emails.


## Project Objective

Develop a reservation platform for a premium hotel establishment.

## Proposed Solution

Create a web application that enables hotel guests to book rooms. The application will offer:

![Architecture Diagram](/images/architecture-v1.jpeg)

### Room Search Feature

- Guests can search for rooms by check-in and check-out dates, with a filter for the number of guests.
- Search results will display a list of room types, each with a "Reserve" button.

### Room Reservation Process

- Guests must provide personal information to book a room.
- The "Reserve" button is enabled after all fields are filled in correctly, and a unique reference number is provided upon reservation.

### Reservation Management

- Guests can view and manage their reservations after logging in.
- Options to update or cancel the reservation are provided for each booking.

### Reservation Modification

- Guests can modify any part of their reservation.

### Reservation Cancellation

- Guests can cancel their reservations easily through the booking system.

### Project Setup Guidance (WIP)
TODO

### Appendix
- Reservation core services (graphQL)

http://localhost:9090/roomgql			


|Resource|Path|Action|Query Param|Path Param|Request|Respons|
| :- | :- | :- | :- | :- | :- | :- |
|Get all available room types|/roomgql||<p>string checking</p><p>Date</p><p></p><p>String checkout Date</p><p></p><p>Int guestCapacity</p>||<p>query RoomTypes {</p><p>`   `roomTypes(</p><p>`       `checkinDate: "2024-04-26T15:00:38.122Z"</p><p>`       `checkoutDate: "2024-04-26T16:00:38.122Z"</p><p>`       `guestCapacity: 1</p><p>`   `) {</p><p>`       `id</p><p>`       `guestCapacity</p><p>`       `price</p><p>`       `name</p><p>`   `}</p><p>}</p><p></p>|<p>"data": {</p><p>`       `"roomTypes": [</p><p>`           `{</p><p>`               `"id": 0,</p><p>`               `"guestCapacity": 1,</p><p>`               `"price": 80,</p><p>`               `"name": "Single"</p><p>`           `},</p><p>`           `{</p><p>`               `"id": 1,</p><p>`               `"guestCapacity": 2,</p><p>`               `"price": 120,</p><p>`               `"name": "Double"</p><p>`           `},</p><p>`           `{</p><p>`               `"id": 3,</p><p>`               `"guestCapacity": 4,</p><p>`               `"price": 300,</p><p>`               `"name": "Suite"</p><p>`           `}</p><p>`       `]</p><p>`   `}</p><p>}</p><p></p>|


- Reservation core services (spring boot services)

http://localhost:8080/reservations 

|Resource|Path|Action|Query Param|Path Param|Request|Respons|
| :- | :- | :- | :- | :- | :- | :- |
|Create new reservation||POST|||<p>{</p><p>`  `"checkinDate": "2024-02-19T14:00:00Z",</p><p>`  `"checkoutDate": "2024-02-20T10:00:00Z",</p><p>`  `"rate": 100,</p><p>`  `"user": {</p><p>`    `"id": "123",</p><p>`    `"name": "waruna",</p><p>`    `"email": "waruna@someemail.com",</p><p>`    `"mobileNumber": "987"</p><p>`  `},</p><p>`  `"roomType": "Family"</p><p>}</p>|<p>{</p><p>"id": "1",</p><p>"checkinDate": "2024-02-19T14:00:00Z",</p><p>"checkoutDate": "2024-02-20T10:00:00Z",</p><p>"user": {</p><p>"id": "123", "name": "waruna", "email":</p><p>"waruna@someemail.com ",</p><p>"mobileNumber": "987"</p><p>}, "room": {</p><p>"number" : 201, "type": {</p><p>"id": 0,</p><p>"name": "Double", "guestCapacity": 2, "price": 100</p><p>} }</p><p></p>|
|Update existing reservation||PUT||reservation\_id|<p>{</p><p>"checkinDate":</p><p>"2024-02-20T14:00:00Z", "checkoutDate":</p><p>"2024-02-21T10:00:00Z" }</p><p></p>|<p>{</p><p>"id": "1",</p><p>"checkinDate": "2024-02-19T14:00:00Z",</p><p>"checkoutDate": "2024-02-21T10:00:00Z",</p><p>"user": {</p><p>"id": "123", "name": "waruna", "email":</p><p>"waruna@someemail.com ",</p><p>"mobileNumber": "987"</p><p>}, "room": {</p><p>"number" : 201, "type": {</p><p>"id": 0,</p><p>"name": "Double", "guestCapacity": 2, "price": 100</p><p>} }</p><p>}</p><p></p>|
|Remove a reservation||DELETE||reservation\_id|||
|Retrieve all reservation for user|/users/|GET||userID||<p>[</p><p>{</p><p>"checkinDate": "2024-02-19T14:00:00Z",</p><p>"checkoutDate": "2024-02-20T10:00:00Z",</p><p>"rate": 120, "user": {</p><p>"id": "123", "name": "waruna", "email":</p><p>"waruna@someemail.com ",</p><p>"mobileNumber": "987"</p><p>},</p><p>"roomType": "Family" },</p><p>{</p><p>"checkinDate":</p><p>"2024-02-23T14:00:00Z", "checkoutDate": "2024-02-24T10:00:00Z",</p><p>"rate": 100, "user": {</p><p>"id": "123", "name": "waruna", "email":</p><p>"waruna@someemail.com ",</p><p>"mobileNumber": "987"</p><p>},</p><p>"roomType": "Double" }</p><p>]</p><p></p>|


- Notification services (python)

http://localhost:8081/notifications 


|Resource|Path|Action|Query Param|Path Param|Request|Respons|
| :- | :- | :- | :- | :- | :- | :- |
|send-email||POST|||<p>{</p><p>`  `"body": "This is a test email.",</p><p>`  `"recipient": "jane.doe@example.com",</p><p>`  `"subject": "Hello World"</p><p>}</p><p></p>|<p>{</p><p>`  `"status":<status update></p><p>}</p><p></p>|