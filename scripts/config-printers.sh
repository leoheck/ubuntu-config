#!/bin/bash

# Crontab Configuration
# Leandro Sehnem Heck (leoheck@gmail.com)

# This script configures the known printes
# - Alunos
# - GAPH
# - Moraes

FILE=/etc/cups/printers.conf
date=$(date +"%Y-%m-%d-%Hh%M")

# backup the original file
if [ -f ${FILE} ]; then
	cp ${FILE} ${FILE}-${date}
fi

# NECESSARIO parar o servico do cups
service cups stop 

#==============================================================================
cat > ${FILE} << END-OF-FILE

<Printer Alunos-Ricoh-Aficio-SP-5210DN-Laser>
UUID urn:uuid:d979d098-d0da-3344-6ff3-485ad85d95b0
Info Impressora Alunos 7o andar, Sala 713
Location sala 713
DeviceURI socket://10.32.175.24:9100
PPDTimeStamp *
State Idle
StateTime 1423669765
Type 8425684
Accepting Yes
Shared Yes
ColorManaged Yes
JobSheets none none
QuotaPeriod 0
PageLimit 0
KLimit 0
OpPolicy default
ErrorPolicy retry-job
Option media 0
Option media-col media-bottom-margin
Option output-bin 0
Option print-color-mode monochrome
Option print-quality 5
Option sides two-sided-long-edge
</Printer>

<DefaultPrinter HP-LaserJet-4250>
UUID urn:uuid:2d75136e-14da-30cc-5f7d-ec6d4090e293
Info HP LaserJet 4250
Location 10.32.162.89
DeviceURI socket://10.32.162.89:9100
PPDTimeStamp *
State Idle
StateTime 1423769357
Reason opc-life-over-warning
Type 8425684
Accepting Yes
Shared Yes
ColorManaged Yes
JobSheets none none
QuotaPeriod 0
PageLimit 0
KLimit 0
OpPolicy default
ErrorPolicy retry-job
Attribute marker-colors none,none
Attribute marker-levels -1,0
Attribute marker-names Black Cartridge HP Q5942A,Maintenance Kit HP 110V-Q5421A, 220V-Q5422A
Attribute marker-types toner-cartridge,fuser
Attribute marker-change-time 1423769357
</Printer>

<Printer Moraes-HP-Deskjet-5520>
UUID urn:uuid:23af4dd8-198d-3f34-52df-23e916f3a60b
Info HP Deskjet 5520 (Moraes)
Location Sala do Moraes
DeviceURI socket://10.32.175.187:9100
PPDTimeStamp *
State Idle
StateTime 1412885339
Type 36892
Accepting Yes
Shared Yes
ColorManaged Yes
JobSheets none none
QuotaPeriod 0
PageLimit 0
KLimit 0
OpPolicy default
ErrorPolicy retry-job
</Printer>

<Printer PDF>
UUID urn:uuid:0888f27b-befd-30c7-5b0a-1ff0aea8a8d2
Info PDF Printer
DeviceURI cups-pdf:/
PPDTimeStamp *
State Idle
StateTime 1420820769
Type 8450124
Accepting Yes
Shared No
ColorManaged Yes
JobSheets none none
QuotaPeriod 0
PageLimit 0
KLimit 0
OpPolicy default
ErrorPolicy retry-job
</Printer>

END-OF-FILE
#==============================================================================

service cups start 
