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

<DefaultPrinter Alunos-Ricoh-Aficio-SP-5210DN-Laser>
UUID urn:uuid:38a9f5b9-cbe7-3771-7e3b-bbcb1c25a5fb
Info Ricoh Aficio SP 5210DN
Location Impressora do 7° Andar
DeviceURI socket://10.32.175.24:9100
PPDTimeStamp *
State Idle
StateTime 1423163546
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
Attribute marker-colors \#000000,#000000
Attribute marker-levels -1,-1
Attribute marker-names Toner,Embalagem de toner usado
Attribute marker-types toner,waste-toner
Attribute marker-change-time 1423163546
</Printer>

<Printer GAPH-HP-Laser-Jet-4250>
UUID urn:uuid:dc69c1d0-2601-3144-4c41-6aa786d5abb1
Info Impressora do GAPH HP LaserJet 4250
Location Sala 727
DeviceURI ipp://10.32.162.55:631/printers/GAPH-HP-Laser-Jet-4250
PPDTimeStamp *
State Idle
StateTime 1421869052
Type 6
Accepting Yes
Shared No
ColorManaged Yes
JobSheets none none
QuotaPeriod 0
PageLimit 0
KLimit 0
OpPolicy default
ErrorPolicy retry-job
Option cups-browsed true
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
