-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("characters/Chars","SELECT * FROM characters")
vRP.Prepare("characters/Person","SELECT * FROM characters WHERE id = @id")
vRP.Prepare("characters/getPhone","SELECT id FROM characters WHERE phone = @phone")
vRP.Prepare("characters/updatePhone","UPDATE characters SET phone = @phone WHERE id = @id")
vRP.Prepare("characters/removeCharacter","UPDATE characters SET deleted = 1 WHERE id = @id")
vRP.Prepare("characters/addFines","UPDATE characters SET fines = fines + @fines WHERE id = @id")
vRP.Prepare("characters/setPrison","UPDATE characters SET prison = @prison WHERE id = @id")
vRP.Prepare("characters/removeFines","UPDATE characters SET fines = fines - @fines WHERE id = @id")
vRP.Prepare("characters/getSerial","SELECT id FROM characters WHERE serial = @serial")
vRP.Prepare("characters/getBlood","SELECT id FROM characters WHERE blood = @blood")
vRP.Prepare("characters/updateDriverlicense","UPDATE driverlicense SET driverlicense = @driverlicense WHERE id = @id")
vRP.Prepare("characters/updatePort","UPDATE characters SET port = @port WHERE id = @id")
vRP.Prepare("characters/updateCriminal","UPDATE characters SET criminal = @criminal WHERE id = @id")
vRP.Prepare("characters/updateBackpack","UPDATE characters SET backpack = @backpack WHERE id = @id")
vRP.Prepare("characters/updateNewbie","UPDATE characters SET newbie = @newbie WHERE id = @id")
vRP.Prepare("characters/updateLocate","UPDATE characters SET locate = @locate WHERE id = @id")
vRP.Prepare("characters/updateSex","UPDATE characters SET sex = @sex WHERE id = @id")
vRP.Prepare("characters/UserSteam","SELECT * FROM characters WHERE id = @id and steam = @steam")
vRP.Prepare("characters/Characters","SELECT * FROM characters WHERE steam = @steam and deleted = 0")
vRP.Prepare("characters/removePrison","UPDATE characters SET prison = prison - @prison WHERE id = @id")
vRP.Prepare("characters/updateName","UPDATE characters SET name = @name, name2 = @name2 WHERE id = @id")
vRP.Prepare("characters/lastCharacters","SELECT id FROM characters WHERE steam = @steam ORDER BY id DESC LIMIT 1")
vRP.Prepare("characters/countPersons","SELECT COUNT(steam) as qtd FROM characters WHERE steam = @steam and deleted = 0")
vRP.Prepare("characters/newCharacter","INSERT INTO characters(steam,name,name2,sex,phone,serial,blood) VALUES(@steam,@name,@name2,@sex,@phone,@serial,@blood)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANK
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("bank/getInfos","SELECT * FROM bank WHERE Passport = @Passport AND mode = @mode AND owner = 1")
vRP.Prepare("bank/newAccount","INSERT INTO bank(Passport,dvalue,mode,owner) VALUES(@Passport,@dvalue,@mode,@owner)")
vRP.Prepare("bank/addValue","UPDATE bank SET dvalue = dvalue + @dvalue WHERE Passport = @Passport AND mode = @mode AND owner = 1")
vRP.Prepare("bank/remValue","UPDATE bank SET dvalue = dvalue - @dvalue WHERE Passport = @Passport AND mode = @mode AND owner = 1")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("accounts/getInfos","SELECT * FROM accounts WHERE steam = @steam")
vRP.Prepare("accounts/newAccount","INSERT INTO accounts(steam) VALUES(@steam)")
vRP.Prepare("accounts/updateWhitelist","UPDATE accounts SET whitelist = 0 WHERE steam = @steam")
vRP.Prepare("accounts/removeGems","UPDATE accounts SET gems = gems - @gems WHERE steam = @steam")
vRP.Prepare("accounts/setPriority","UPDATE accounts SET priority = @priority WHERE steam = @steam")
vRP.Prepare("accounts/infosUpdatechars","UPDATE accounts SET chars = chars + 1 WHERE steam = @steam")
vRP.Prepare("accounts/AddGems","UPDATE accounts SET gems = gems + @gems WHERE steam = @steam")
vRP.Prepare("accounts/updatePremium","UPDATE accounts SET premium = premium + 2592000 WHERE steam = @steam")
vRP.Prepare("accounts/SetPremium","UPDATE accounts SET premium = @premium, priority = @priority WHERE steam = @steam")
vRP.Prepare("accounts/updateMedicPlan","UPDATE accounts SET medicplan = medicplan + 2592000 WHERE steam = @steam")
vRP.Prepare("accounts/SetMedicPlan","UPDATE accounts SET medicplan = @medicplan WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("playerdata/GetData","SELECT dvalue FROM playerdata WHERE Passport = @Passport AND dkey = @dkey")
vRP.Prepare("playerdata/SetData","REPLACE INTO playerdata(Passport,dkey,dvalue) VALUES(@Passport,@dkey,@dvalue)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYDATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("entitydata/RemoveData","DELETE FROM entitydata WHERE dkey = @dkey")
vRP.Prepare("entitydata/GetData","SELECT dvalue FROM entitydata WHERE dkey = @dkey")
vRP.Prepare("entitydata/SetData","REPLACE INTO entitydata(dkey,dvalue) VALUES(@dkey,@dvalue)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("vehicles/plateVehicles","SELECT * FROM vehicles WHERE plate = @plate")
vRP.Prepare("vehicles/UserVehicles","SELECT * FROM vehicles WHERE Passport = @Passport")
vRP.Prepare("vehicles/removeVehicles","DELETE FROM vehicles WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/selectVehicles","SELECT * FROM vehicles WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/paymentArrest","UPDATE vehicles SET arrest = 0 WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/moveVehicles","UPDATE vehicles SET Passport = @OtherPassport WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/plateVehiclesUpdate","UPDATE vehicles SET plate = @plate WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/rentalVehiclesDays","UPDATE vehicles SET rental = rental + 2592000 WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/arrestVehicles","UPDATE vehicles SET arrest = UNIX_TIMESTAMP() + 2592000 WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/updateVehiclesTax","UPDATE vehicles SET tax = UNIX_TIMESTAMP() + 2592000 WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/rentalVehiclesUpdate","UPDATE vehicles SET rental = UNIX_TIMESTAMP() + 2592000 WHERE Passport = @Passport AND vehicle = @vehicle")
vRP.Prepare("vehicles/addVehicles","INSERT IGNORE INTO vehicles(Passport,vehicle,plate,work,tax) VALUES(@Passport,@vehicle,@plate,@work,UNIX_TIMESTAMP() + 604800)")
vRP.Prepare("vehicles/rentalVehicles","INSERT IGNORE INTO vehicles(Passport,vehicle,plate,work,rental,tax) VALUES(@Passport,@vehicle,@plate,@work,UNIX_TIMESTAMP() + 2592000,UNIX_TIMESTAMP() + 604800)")
vRP.Prepare("vehicles/updateVehicles","UPDATE vehicles SET engine = @engine, body = @body, health = @health, fuel = @fuel, doors = @doors, windows = @windows, tyres = @tyres, nitro = @nitro WHERE Passport = @Passport AND vehicle = @vehicle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("prison/cleanRecords","DELETE FROM prison WHERE OtherPassport = @OtherPassport")
vRP.Prepare("prison/getRecords","SELECT * FROM prison WHERE OtherPassport = @OtherPassport ORDER BY id DESC")
vRP.Prepare("prison/insertPrison","INSERT INTO prison(police,OtherPassport,services,fines,text,date) VALUES(@police,@OtherPassport,@services,@fines,@text,@date)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNEDS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("banneds/GetBanned","SELECT * FROM banneds WHERE steam = @steam")
vRP.Prepare("banneds/RemoveBanned","DELETE FROM banneds WHERE steam = @steam")
vRP.Prepare("banneds/InsertBanned","INSERT INTO banneds(steam,token,time) VALUES(@steam,@token,UNIX_TIMESTAMP() + 86400 * @time)")
vRP.Prepare("banneds/GetToken","SELECT * FROM banneds WHERE token = @token LIMIT 1")
vRP.Prepare("banneds/InsertToken","INSERT INTO banneds(steam,token) VALUES(@steam,@token)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("chests/GetChests","SELECT * FROM chests WHERE name = @name")
vRP.Prepare("chests/UpdateChests","UPDATE chests SET weight = weight + 10 WHERE name = @name")
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("races/Result","SELECT * FROM races WHERE Race = @Race AND Passport = @Passport")
vRP.Prepare("races/Ranking","SELECT * FROM races WHERE Race = @Race ORDER BY Points ASC LIMIT 5")
vRP.Prepare("races/TopFive","SELECT * FROM races WHERE Race = @Race ORDER BY Points ASC LIMIT 1 OFFSET 4")
vRP.Prepare("races/Records","UPDATE races SET Points = @Points, Vehicle = @Vehicle WHERE Race = @Race AND Passport = @Passport")
vRP.Prepare("races/Insert","INSERT INTO races(Race,Passport,Name,Vehicle,Points) VALUES(@Race,@Passport,@Name,@Vehicle,@Points)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("fidentity/Result","SELECT * FROM fidentity WHERE id = @id")
vRP.Prepare("fidentity/GetIdentity","SELECT id FROM fidentity ORDER BY id DESC LIMIT 1")
vRP.Prepare("fidentity/NewIdentity","INSERT INTO fidentity(name,name2,blood) VALUES(@name,@name2,@blood)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARTABLES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("clear/Playerdata","DELETE FROM playerdata WHERE dvalue = '[]' OR dvalue = '{}'")
vRP.Prepare("clear/Entitydata","DELETE FROM entitydata WHERE dvalue = '[]' OR dvalue = '{}'")
vRP.Prepare("clear/cleanPremium","UPDATE accounts SET premium = '0', priority = '0' WHERE UNIX_TIMESTAMP() >= premium")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WAREHOUSE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("warehouse/Informations","SELECT * FROM warehouse WHERE name = @name")
vRP.Prepare("warehouse/Upgrade","UPDATE warehouse SET weight = weight + 10 WHERE name = @name")
vRP.Prepare("warehouse/Password","UPDATE warehouse SET password = @password WHERE name = @name")
vRP.Prepare("warehouse/Acess","SELECT * FROM warehouse WHERE name = @name AND password = @password")
vRP.Prepare("warehouse/Tax","UPDATE warehouse SET tax = UNIX_TIMESTAMP() + 2592000 WHERE name = @name")
vRP.Prepare("warehouse/Buy","INSERT INTO warehouse(name,password,Passport,tax) VALUES(@name,@password,@Passport,UNIX_TIMESTAMP() + 2592000)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("propertys/All","SELECT * FROM propertys")
vRP.Prepare("propertys/Sell","DELETE FROM propertys WHERE Name = @name")
vRP.Prepare("propertys/Exist","SELECT * FROM propertys WHERE Name = @name")
vRP.Prepare("propertys/Serial","SELECT * FROM propertys WHERE Serial = @serial")
vRP.Prepare("propertys/Garages","SELECT * FROM propertys WHERE Garage IS NOT NULL")
vRP.Prepare("propertys/AllUser","SELECT * FROM propertys WHERE Passport = @Passport")
vRP.Prepare("propertys/Garage","UPDATE propertys SET Garage = @garage WHERE Name = @name")
vRP.Prepare("propertys/Keys","UPDATE propertys SET Keys = Keys + @keys WHERE Name = @name")
vRP.Prepare("propertys/Credentials","UPDATE propertys SET Serial = @serial WHERE Name = @name")
vRP.Prepare("propertys/Vault","UPDATE propertys SET Vault = Vault + @weight WHERE Name = @name")
vRP.Prepare("propertys/Fridge","UPDATE propertys SET Fridge = Fridge + @weight WHERE Name = @name")
vRP.Prepare("propertys/Check","SELECT * FROM propertys WHERE Name = @name AND Passport = @Passport")
vRP.Prepare("propertys/Tax","UPDATE propertys SET Tax = UNIX_TIMESTAMP() + 2592000 WHERE Name = @name")
vRP.Prepare("propertys/Buy","INSERT INTO propertys(Name,Interior,Passport,Serial,Vault,Fridge,Tax) VALUES(@name,@interior,@passport,@serial,@vault,@fridge,@tax)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCLEANERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	vRP.Query("clear/Playerdata")
	vRP.Query("clear/Entitydata")
	vRP.Query("clear/cleanPremium")
end)