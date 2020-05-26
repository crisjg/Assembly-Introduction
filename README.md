# Assembly-Introduction
Intro to Assembly

This contains a given condition to test undertanding of PIC18 Assembly Language schematic and developement board provided by instuctor.
 
```
1) Use the two switches connected to PORT A bits 1 and 0 as inputs. 
2) Based on those two inputs, make the LED D2 blink ON and OFF with the color and frequency as indicated on the table below. 
The LED D1 will always blink with the WHITE color
3) Place a scope probe at any pin of D1 to measure the period of that signal. The precision should be at +/-0.2 msec. 
Since D1 is always WHITE, any pin of D1 should reflect the blinking period of the LED D2

  PORT A             PORT D (bits 2 - 4)
Bit_1 Bit_0          Action
  0     0            RED color blinking every 10 msec
  0     1            GREEN color blinking every 20 msec
  1     0            BLUE color blinking every 40 msec
  1     1            WHITE color blinking every 100 msec
  

```
