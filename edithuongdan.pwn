#define     MAX_Tutorial            10
#define     Tutorial_MAX_NAME_LEN   100

new ATTUTORIAL = 0;

enum TutorialData {
    TutorialSQLId,
	hd_szTutorialName[Tutorial_MAX_NAME_LEN],
}

new stock
	arrTutorial[MAX_Tutorial][TutorialData];

forward ATurorial();
public ATurorial()
{
	new szMessage[128], iCount = random(10);
	if(arrTutorial[iCount][hd_szTutorialName] != 0)
	{
		format(szMessage, sizeof(szMessage), "{FFFF00}[Huong Dan]: {FFFFFF}%s .", arrTutorial[iCount][hd_szTutorialName]);
		SendClientMessageToAll(COLOR_WHITE, szMessage);
	}
	else ATurorial();
	return 1;
}

stock LoadTutorial(tutorialid)
{
	new string[128];
	mysql_format(MainPipeline, string, sizeof(string), "SELECT * FROM `attutorial` WHERE `ID`=%d", tutorialid+1);
	mysql_tquery(MainPipeline, string, "OnLoadTutorial", "i", tutorialid);
}

stock LoadTutorials()
{
	printf("[LoadTutorial] Loading data from database...");
	mysql_tquery(MainPipeline, "SELECT * FROM `attutorial`", "OnLoadTutorials", "");
}

forward OnLoadTutorial(index);
public OnLoadTutorial(index)
{
	new rows;
	cache_get_row_count(rows);

	for(new row; row < rows; row++)
	{
		cache_get_value_name_int(row, "ID", arrTutorial[index][TutorialSQLId]);
		cache_get_value_name(row, "Name", arrTutorial[index][hd_szTutorialName], 128);
	}
	return 1;
}

forward OnLoadTutorials();
public OnLoadTutorials()
{
	new i, rows;
	cache_get_row_count(rows);

	while(i < rows)
	{
		LoadTutorial(i);
		i++;
	}
}

stock RehashTutorial(tutorialid)
{
	printf("[RehashTutorial] Deleting Tutorial #%d from server...", tutorialid);
	arrTutorial[tutorialid][TutorialSQLId] = -1;
	LoadTutorials(tutorialid);
}

stock RehashTutorials()
{
	printf("[RehashTutorial] Deleting Deleting Tutorial server...");
	for(new i = 0; i < MAX_Tutorial; i++)
	{
		RehashTutorial(i);
	}
	LoadTutorials();
}

stock SaveTutorials()
{
	for(new i = 0; i < MAX_Tutorial; i++)
	{
		SaveTutorial(i);
	}
	return 1;
}

stock SaveTutorial(iTutorialID){
	new string[1024];
    mysql_format(MainPipeline, string, sizeof(string), "UPDATE `attutorial` SET `Name`='%s' WHERE `ID` = '%d'", arrTutorial[iTutorialID][hd_szTutorialName], iTutorialID+1);
    mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
}

ATutorial_Show(playerid)
{
    new string[MAX_Tutorial * (Tutorial_MAX_NAME_LEN + 20)], i;
    while(i < MAX_Tutorial)
    {
        if(arrTutorial[i][hd_szTutorialName]) {
            format(string, sizeof(string), "%s\n(ID:%d) %s", string, i+1, arrTutorial[i][hd_szTutorialName]);
        }
        else
        {
            format(string, sizeof string, "%s\n(%i) (-----)", string, i+1);
        }
		
        SaveTutorial(i);
        ++i;
    }
    return Dialog_Show(playerid, ATutorial_Pick, DIALOG_STYLE_LIST, "Tutorial List", string, "Chon", "Huy");
}

Dialog:ATutorial_Pick(playerid, response, listitem, inputtext[])
{
    if(response)
	{
        new string[128];
        SetPVarInt(playerid, "Tutorial_EditID", listitem);
        format(string, sizeof(string), "Ten: %s\nDelete Name Tutorial", arrTutorial[listitem][hd_szTutorialName]);
		return Dialog_Show(playerid, ATutorial_EditTutorial, DIALOG_STYLE_LIST, "Tutorial Edit Name ", string, "Sua", "Huy");
	}
	return 1;
}

Dialog:ATutorial_EditTutorial(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new
			iTutorialID = GetPVarInt(playerid, "Tutorial_EditID");
        switch(listitem)
        {
            case 0: {
                Dialog_Show(playerid, ATutorial_EditName, DIALOG_STYLE_INPUT, "SUA TEN TUTORIAL", "Nhap Ten Tutorial muon chinh sua", "Sua", "Huy");
            }
            case 1: {
				mysql_format(MainPipeline, szMiscArray, sizeof(szMiscArray), "DELETE FROM `attutorial` WHERE `ID` = '%d' AND `Name` = '%s'", iTutorialID+1, arrTutorial[iTutorialID][hd_szTutorialName]);
				mysql_tquery(MainPipeline, szMiscArray, "OnQueryFinish", "i", SENDDATA_THREAD);
                arrTutorial[iTutorialID][hd_szTutorialName] = 0;

                return ATutorial_Show(playerid);
            }
        }
    }
    return 1;
}

Dialog:ATutorial_EditName(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        new
			iTutorialID = GetPVarInt(playerid, "Tutorial_EditID"),
			string[128];
        
        if(!(5 < strlen(inputtext) < Tutorial_MAX_NAME_LEN))
        {
            return Dialog_Show(playerid, ATutorial_EditName, DIALOG_STYLE_INPUT, "LOI NHAP KY TU", "Nhap ky tu tu 5 - "#Tutorial_MAX_NAME_LEN"\nVui long nhap lai", "Sua", "Huy");
        }
		else if(arrTutorial[iTutorialID][hd_szTutorialName] > 0)
		{
			SendClientMessage(playerid, -1, "Delete Name Tutorial - Moi Co The Sua Ten Moi");
			return 1;
		}
        strcpy(arrTutorial[iTutorialID][hd_szTutorialName], inputtext);
		mysql_format(MainPipeline, string, sizeof(string), "INSERT INTO `attutorial`(`ID`,`Name`) VALUES ('%d','%s')", iTutorialID+1, inputtext);
		mysql_tquery(MainPipeline, string, "OnQueryFinish", "i", SENDDATA_THREAD);
        return ATutorial_Show(playerid);
    }
    return 1;
}

CMD:edithuongdan(playerid, params[]) {
	if(PlayerInfo[playerid][pAdmin] >= 1338)
	{
        if(ATTUTORIAL == 0)
        {
            ATutorial_Show(playerid);
            return 1;
        }
        return SendClientMessageEx(playerid, COLOR_GRAD2, "Tat chuc nang AUTO Tutorial truoc khi Chinh Sua - /autott");
	}
	return 1;
}

CMD:autott(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1337) {
        SendClientMessageEx(playerid, COLOR_GRAD2, "Ban khong duoc phep su dung lenh nay.");
        return 1;
    }
	if(ATTUTORIAL == 0)
	{
	    SetPVarInt(playerid, "ATTutorial", SetTimerEx("ATurorial", 900000, true, "i", playerid));
		SendClientMessageEx(playerid, COLOR_GRAD2, "Bat chuc nang AUTO Tutorial.");
		ATTUTORIAL = 1;
		return 1;
	}
	else if(ATTUTORIAL == 1)
	{
		KillTimer(GetPVarInt(playerid, "ATTutorial"));
		SendClientMessageEx(playerid, COLOR_GRAD2, "Tat chuc nang AUTO Tutorial.");
		ATTUTORIAL = 0;
		return 1;
	}
    return 1;
}