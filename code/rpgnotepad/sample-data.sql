--
--CREATE TABLE "campaigns" (    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
--                              "name" VARCHAR(50)
--);
insert into campaigns (id, name) values (1, "Test Campaign 1");

--CREATE TABLE "users" (    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
--);
insert into users (id) values (10);
insert into users (id) values (11);
insert into users (id) values (12);

--CREATE TABLE "players" (    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
--                            "user_id" INTEGER NOT NULL, 
--                            "campaign_id" INTEGER NOT NULL, 
--                            "name" VARCHAR(50)
--);
insert into players (id, user_id, campaign_id, name) values (100, 10, 1, "Player One");

--CREATE TABLE "encounters" (   "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
--                              "campaign_id" INTEGER NOT NULL, "name" VARCHAR(50)
--);
insert into encounters (id, campaign_id) values (2, 1);

--CREATE TABLE "gamerunners" (  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
--                              "user_id" INTEGER NOT NULL, "campaign_id" INTEGER NOT NULL
--);

--CREATE TABLE "nonplayercharacters" (  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
--                                      "name" VARCHAR(50), 
--                                      "abbreviated_name" VARCHAR(50), 
--                                      "encounter_id" INTEGER NOT NULL
--);

--CREATE TABLE "playercharacters" (   "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
--                                    "name" VARCHAR(50),
--                                    "abbreviated_name" VARCHAR(50), 
--                                    "player_id" INTEGER NOT NULL
--);

--CREATE TABLE "encounter_playercharacters" ( "encounter_id" INTEGER NOT NULL, 
--                                            "playercharacter_id" INTEGER NOT NULL, 
--                                            PRIMARY KEY("encounter_id", "playercharacter_id")
--);
insert into encounter_playercharacters (encounter_id, playercharacter_id) values (,);

--CREATE INDEX "index_encounters_campaign" ON "encounters" ("campaign_id");
--CREATE INDEX "index_gamerunners_campaign" ON "gamerunners" ("campaign_id");
--CREATE INDEX "index_gamerunners_user" ON "gamerunners" ("user_id");
--CREATE INDEX "index_nonplayercharacters_encounter" ON "nonplayercharacters" ("encounter_id");
--CREATE INDEX "index_playercharacters_player" ON "playercharacters" ("player_id");
--CREATE INDEX "index_players_campaign" ON "players" ("campaign_id");
--CREATE INDEX "index_players_user" ON "players" ("user_id");
