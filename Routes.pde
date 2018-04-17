Boolean SETBUTTS = false;
String ExecStr;


void Router(String go, String msg) {  //
  println("<--- Router(go, msg: " 
    +go
    +", "
    +msg
    );

  String updateText = "";


  if (go == "rgbR" || go == "rgbG" || go == "rgbB") {
    cPick = color(rgbR, rgbG, rgbB, 100);
    offBlack = color (rgbR*.25, rgbG*.25, rgbB*.25);
    println ("SEEEEE "+SETBUTTS);

    if (SETBUTTS) {  // the slider change conditions should only be reached when SETBUTTS, anyway, but this ensures no GUI events get confused.
      for (Light light : lights) {
        println("is it this <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        butts[light.buttI].setColorForeground(cPick); // foreground is when hovered  //DEBUG
        //butts[light.buttI].setColorActive(cPick);  // active is when ON
      }
    }
  }



  switch(go) {
  case "start":
    UnPause();
    break;
  case "exec_B":
    ExecStr = "";
    for (Light light : lights) {  //look through light array and build serial msg based on settings
      String GetMsg = LightMsg(light.buttI);//null,null,light.buttI);
      println(GetMsg);
      ExecStr = ExecStr + GetMsg;
    }  
    print ("hey bozo: "+ExecStr);
    //UpdateUI(ExecStr);
    if (CONNECTED) {
      WritePort(ExecStr);
    } else {
      println ("not connected");
      UpdateUI("No serial connectin has been achieved.");
    }

    break;
  case "g3": // GUI group 3, program menu
    SETBUTTS = Boolean.parseBoolean(msg);  //str convert message to bool true/false

    if (SETBUTTS) {
      STOPCOLOR=false;
      for (int i = 0; i<lightCount; i++) {
        //color1[i]=butts[i].getColor().getForeground(); //get the current BG color
        lights[i].Program(Boolean.valueOf(msg), i);
      }
    } else {  //leaving set mode; restore the colors to the BG color
      for (int i = 0; i<lightCount; i++) {
        //butts[i].setColorBackground(colBG[i]);
        lights[i].Program(Boolean.valueOf(msg), i);
        //println(hex(color1[i], 6));
        //colBG[i]=butts[i].getColor().getBackground(); //get the current BG color
        //lights[i].Program(Boolean.valueOf(msg), i);
      }
    }
    //for (Light light : lights) {

    //  light.Program(Boolean.valueOf(msg), light.buttI);
    //}
    //if (!SETBUTTS) {
    //  for (Light light : lights) {    
    //    butts[light.buttI].setColorBackground(offBlack);
    //  }
    //}
    break;
  case "lounge_count":
    updateText = (lounge_count +" lounges zoned");
    break;
  case "connect_B":
    if (!CONNECTED) {
      try {
        if (Serial.list()[0].isEmpty()) {
          port= new Serial(this, Serial.list()[0], 9600);
        }
        updateText = "Wahooo! connected @ "+Serial.list()[0];
        CON_CHANGED = true;
      } 
      catch (Exception e) {
        updateText = "Booo, can't find a valid serial connection!  :(";
      }
    } else {
      updateText = "Ok, I'll disconnect...";
      CON_CHANGED=true;
    }
    break;
  case "out":
    updateText = msg;
    if (CONNECTED) {
      updateText = "dance, slime! "+updateText;
      Router("exec_B", ""); //send to the execute routine to sweep all the lights to the serial port
      return;
    } else {
      updateText = "set msg: " + updateText;
    }
    break;
  default:
    println("default case, no actions here yet");
    return; //this return breaks the light button listener event to prevent the rest of router control
  }
  UpdateUI(updateText);
  console.scroll(.9);
}

//**************************************************************
void controlEvent(ControlEvent theEvent) {
  println("*** GUI EVENT");
  String conName="";
  if (theEvent.isController()) {
    conName =  theEvent.getController().getName();
    println ("This isController: "+conName);
    Router(conName, null);
  }
  if (theEvent.isGroup()) {
    String ISOPEN = str(theEvent.getGroup().isOpen());
    println("got an event from group "
      +theEvent.getGroup().getName()
      +", isOpen? "+theEvent.getGroup().isOpen()
      );
    conName =  theEvent.getGroup().getName();
    Router(conName, ISOPEN);
  }


  //if (theEvent.isController()) println(theEvent.getController().getName());
  //if (theEvent.isGroup()) println(theEvent.getGroup().getName());  
  //String conName = theEvent.getController().getName();
  //println(conName);

  //  if (theEvent.getGroup().getName() == "SetupGrp") {
  //    if (theEvent.getGroup().isOpen()) {
  //      println("yaaas");
  //      origValue = loungeCount;
  //    } else {
  //    }
  //  }
  //} else if (theEvent.isController()) {
  //  String guest =theEvent.getController().getName(); 
  //  println("got something from a controller "
  //    +guest
  //    );
  //  if (guest == "connect_B") {
  //    if (CONNECTED) {
  //    } else {
  //      SetCom();
  //    }
  //  }
  //}
}