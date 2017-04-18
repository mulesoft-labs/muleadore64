!zone load_resources

.address_sid = $1001
.address_data = $2000  ; 8192

* = .address_sid
!bin "resources/empty_1000.sid",, $7c+2  ; remove header from sid and cut off original loading address 

* = .address_data

!bin "resources/mule.spr"  ; (512)

!bin "resources/mule-logo.spr" ;(512)

!bin "resources/twitter.spr" ;(512)