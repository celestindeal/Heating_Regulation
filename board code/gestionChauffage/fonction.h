IPAddress timeServer(129, 6, 15, 28);
const int NTP_PACKET_SIZE = 48;
byte packetBuffer[ NTP_PACKET_SIZE];  
String monheure = String();


unsigned long sendNTPpacket(IPAddress& address, WiFiUDP Udp) {

  memset(packetBuffer, 0, NTP_PACKET_SIZE);

  packetBuffer[0] = 0b11100011;   // LI, Version, Mode
  packetBuffer[1] = 0;     // Stratum, or type of clock
  packetBuffer[2] = 6;     // Polling Interval
  packetBuffer[3] = 0xEC;

  packetBuffer[12]  = 49;
  packetBuffer[13]  = 0x4E;
  packetBuffer[14]  = 49;
  packetBuffer[15]  = 52;

  Udp.beginPacket(address, 123); 
  Udp.write(packetBuffer, NTP_PACKET_SIZE);
  Udp.endPacket();
  Serial.println(packetBuffer[15]);
}

String time(WiFiUDP Udp) {
  // send an NTP request to the time server at the given address
  
    
  
  sendNTPpacket(timeServer, Udp);
  delay(1000);

  if (Udp.parsePacket()) {

    Udp.read(packetBuffer, NTP_PACKET_SIZE);

    unsigned long highWord = word(packetBuffer[40], packetBuffer[41]);
    unsigned long lowWord = word(packetBuffer[42], packetBuffer[43]);

    unsigned long secsSince1900 = highWord << 16 | lowWord;

    const unsigned long seventyYears = 2208988800UL;

    unsigned long epoch = secsSince1900 - seventyYears;
    int heure  = ((epoch  % 86400L) / 3600);
    int minute  = ((epoch  % 3600) / 60);
    int seconde  = (epoch % 60);


    monheure = heure;
    monheure += ":";
    monheure += minute;
    monheure += ":";
    monheure += seconde;
    return monheure;
  }
  return "null";

}


