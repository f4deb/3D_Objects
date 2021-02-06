                   .:                     :,                                          
,:::::::: ::`      :::                   :::                                          
,:::::::: ::`      :::                   :::                                          
.,,:::,,, ::`.:,   ... .. .:,     .:. ..`... ..`   ..   .:,    .. ::  .::,     .:,`   
   ,::    :::::::  ::, :::::::  `:::::::.,:: :::  ::: .::::::  ::::: ::::::  .::::::  
   ,::    :::::::: ::, :::::::: ::::::::.,:: :::  ::: :::,:::, ::::: ::::::, :::::::: 
   ,::    :::  ::: ::, :::  :::`::.  :::.,::  ::,`::`:::   ::: :::  `::,`   :::   ::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  :::::: ::::::::: ::`   :::::: ::::::::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  .::::: ::::::::: ::`    ::::::::::::::: 
   ,::    ::.  ::: ::, ::`  ::: ::: `:::.,::   ::::  :::`  ,,, ::`  .::  :::.::.  ,,, 
   ,::    ::.  ::: ::, ::`  ::: ::::::::.,::   ::::   :::::::` ::`   ::::::: :::::::. 
   ,::    ::.  ::: ::, ::`  :::  :::::::`,::    ::.    :::::`  ::`   ::::::   :::::.  
                                ::,  ,::                               ``             
                                ::::::::                                              
                                 ::::::                                               
                                  `,,`


http://www.thingiverse.com/thing:3195452
Filament Runout Sensor by james04si is licensed under the Creative Commons - Attribution - Non-Commercial - Share Alike license.
http://creativecommons.org/licenses/by-nc-sa/3.0/

# Summary

I was Searching thingiverse for a filament runout sensor that uses the basic X,Y,Z end stop boards that most RAMPS kits come with and couldn’t find one that I liked. This one will mount to your 2020,2040,etc. extrusion. It uses M3 nuts and bolts to assemble and connects to your extrusion with M5 bolts and T-Nuts. You can use it with or without PTFE for your bowden and direct drive applications to automatically pause your machine when you run out of filament saving you from a failed print just because you just ran out of filament. There are 2 versions of the file. The original with mounting tabs and one without tabs. 


To enable the Filament Runout Sensor in marlin you need to define and comment this line changing #define FIL_RUNOUT_INVERTING to true in Configuration.h

#define FILAMENT_RUNOUT_SENSOR
#if ENABLED(FILAMENT_RUNOUT_SENSOR)
  #define NUM_RUNOUT_SENSORS   1     // Number of sensors, up to one per extruder. Define a FIL_RUNOUT#_PIN for each.
  #define FIL_RUNOUT_INVERTING true  // set to true to invert the logic of the sensor.
  #define FIL_RUNOUT_PULLUP          // Use internal pullup for filament runout pins.
  #define FILAMENT_RUNOUT_SCRIPT "M600"
#endif

You also need to define and comment this line in Configuration_adv.h

#define ADVANCED_PAUSE_FEATURE


The lead on the end stop is mispinned to use on your servo header. You will need to depin the red and black pins and swap them so that the plug goes Green, Red, Black order. You Plug the sensor into SERVO3. On a RAMPS board this is the 4th set of pins on the servo header since it starts from the left as SERVO0.


# Print Settings

Printer: CoreXY
Rafts: No
Supports: No
Resolution: .2
Infill: 25
Filament_brand: Inland
Filament_color: Blue
Filament_material: PETG