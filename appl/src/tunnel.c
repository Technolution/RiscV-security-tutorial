/*
  (C) COPYRIGHT 2016 TECHNOLUTION B.V., GOUDA NL
  =======          I                   ==          I    =
     I             I                    I          I
|    I   ===   === I ===  I ===   ===   I  I    I ====  I   ===  I ===
|    I  /   \ I    I/   I I/   I I   I  I  I    I  I    I  I   I I/   I
|    I  ===== I    I    I I    I I   I  I  I    I  I    I  I   I I    I
|    I  \     I    I    I I    I I   I  I  I   /I  \    I  I   I I    I
|    I   ===   === I    I I    I  ===  ===  === I   ==  I   ===  I    I
|                 +---------------------------------------------------+
+----+            |  +++++++++++++++++++++++++++++++++++++++++++++++++|
     |            |             ++++++++++++++++++++++++++++++++++++++|
     +------------+                          +++++++++++++++++++++++++|
                                                        ++++++++++++++|
                                                                 +++++|
 */

/**
 * Implementation for a very simple tunnel control system.
 *
 * The system is for a very narrow tunnel where vehicles can pass from only one side at a time.
 * A green light on both sides of the tunnel indicates from which side drivers can enter the
 * tunnel. A wait time allows drivers to leave the tunnel before vehicles can enter from the
 * other side.
 *
 * The paramters (green-time and wait-time) can be controlled to optimize for latency during
 * normal operation and optimize for throughput during rush hour.
 */

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"

#include "clib.h"
#include "led.h"
#include "tunnel.h"

int greenTime = 2;
int waitTime = 2;

static void vTunnelTask( void *pvParameters );
void InitTunnelTask(void);

void setGreenTime(int newVal) {
	greenTime = newVal;
}

void setWaitTime(int newVal) {
	waitTime = newVal;
}

int getGreenTime(void) {
	return greenTime;
}

int getWaitTime(void) {
	return waitTime;
}

void InitTunnelTask(void) {
	xTaskCreate(vTunnelTask, "TunnelTask", configMINIMAL_STACK_SIZE, NULL, 1, NULL );
}

static void vTunnelTask( void *pvParameters ) {
    (void)pvParameters;

	for(;;){
		setLed(0, 0);
		setLed(2, 1);
		writeLeds();
		vTaskDelay(greenTime * 1000);
		setLed(0, 0);
		setLed(2, 0);
		writeLeds();
		vTaskDelay(waitTime * 1000);
		setLed(0, 1);
		setLed(2, 0);
		writeLeds();
		vTaskDelay(greenTime * 1000);
		setLed(0, 0);
		setLed(2, 0);
		writeLeds();
		vTaskDelay(waitTime * 1000);
	}
}

