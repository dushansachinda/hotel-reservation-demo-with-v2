package org.choreo.demo.luxury.hotels.event;

import org.choreo.demo.luxury.hotels.model.Reservation;
import org.choreo.demo.luxury.hotels.model.ReservationEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;


@Service
public class KafkaProducerService {

  private static final Logger logger = LoggerFactory.getLogger(KafkaProducerService.class);
  private static final String TOPIC = "notifications";

  @Autowired
  private KafkaTemplate<String, Object> kafkaTemplate;

  public void sendMessage(Reservation reservation, ReservationEvent event) {
    logger.info(String.format("#### -> reservation created and dispatch to KAFKA broker -> %s", reservation.getId()));
    String stringNumber = String.format("%d", reservation.getId());

    // send notification
    switch (event) {
      case ReservationCreated:
        logger.info("NotificationService: Sending reservation created notification to user: "
            + reservation.getUser().getId());
        kafkaTemplate.send(TOPIC, "CREATED",reservation);
        break;
      case ReservationUpdated:
        logger.info("NotificationService: Sending reservation updated notification to user: "
            + reservation.getUser().getId());
            kafkaTemplate.send(TOPIC, "UPDATED",reservation);
        break;
      case ReservationDeleted:
        logger.info("NotificationService: Sending reservation cancelled notification to user: "
            + reservation.getUser().getId());
            kafkaTemplate.send(TOPIC, "DELETED",reservation);
        break;
    }
  }
}