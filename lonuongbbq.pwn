//placebbq : Đặt lò nướng BBQ, yêu cầu: có House + trong phạm vi House tùy theo hLevel [1-5]
//destroybbq : Xóa lò nướng BBQ, yêu cầu: Đã đặt lò nướng BBQ trước đó
//dichvugiaohangbbq : Gọi dịch vụ giao hàng BBQ, sẽ phát thông báo đến người chơi nào đang xin việc Job == 20, 21
//huydichvubbq : Hủy dịch vụ giao hàng BBQ, dành cho người chơi [/dichvugiaohangbbq] và sẽ phát thông báo đến người chơi nào đang xin việc Job == 20, 21
//chapnhangiaohangbbq [playerid] : Chấp nhận giao hàng BBQ yêu cầu: Xin việc Job == 20, 21 và ngồi trên xe của Job đó, và set checkpoint đến House người chơi đã gọi dịch vụ
//huygiaohangbbq : Hủy giao hàng BBQ trước đó đã [/chapnhangiaohangbbq [playerid]]


/* stock SendBBQMessage(JobBBQ, Job2BBQ, color, string[])
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pJob] == JobBBQ || PlayerInfo[i][pJob2] == JobBBQ || PlayerInfo[i][pJob] == Job2BBQ || PlayerInfo[i][pJob2] == Job2BBQ)
		{
			{
				SendClientMessageEx(i, color, string[]);
			}
		}
	}
} */

stock SendBBQMessage(job, color, const string[])
{
	foreach(new i : Player)
	{
		if(PlayerInfo[i][pJob] == job || PlayerInfo[i][pJob2] == job || PlayerInfo[i][pJob3] == job) {
			SendClientMessageEx(i, color, string);
		}
	}
}

ProxDetectorObject(giveplayerid, targetid)
{
	new Float:x = GetPVarFloat(giveplayerid, "lonuongBBQX"), Float:y = GetPVarFloat(giveplayerid, "lonuongBBQY"), Float:z = GetPVarFloat(giveplayerid, "lonuongBBQZ");
	new Float: rangebqb = GetPlayerDistanceFromPoint(targetid, x, y, z);
	if(rangebqb <= 10)
	{
		return 1;
	}
    return 0;
}

forward StartLoNuongBBQ(giveplayerid, loaithit, Phut, Giay);
public StartLoNuongBBQ(giveplayerid, loaithit, Phut, Giay)
{
    new string[128];
    new Float:x = GetPVarFloat(giveplayerid, "lonuongBBQX"), Float:y = GetPVarFloat(giveplayerid, "lonuongBBQY"), Float:z = GetPVarFloat(giveplayerid, "lonuongBBQZ");
    switch(loaithit)
    {
        case 1:
        {
            if(GetPVarInt(giveplayerid, "idlonuongBBQ") == -1)
            {
                Phut = 0;
                Giay = 0;
            }
            else if(GetPVarInt(giveplayerid, "MeatFlame") == 1)
            {
                DeletePVar(giveplayerid, "MeatFlame");
                SetPVarInt(giveplayerid, "objectMeatBBQ", CreateDynamicObject(2804, x, y, z+0.9, 0, 0, 0));
                SetPVarInt(giveplayerid, "objectFlameBBQ", CreateDynamicObject(18693, x, y+0.2, z-0.8, 0, 0, 0));
            }
            Giay--;
            format(string, sizeof(string), "Thoi Gian: {FFFFFF}%d:%d", Phut, Giay);
            UpdateDynamic3DTextLabelText(Text3D:GetPVarInt(giveplayerid, "text3dtimerBBQ"), COLOR_YELLOW, string);
            if(Giay > 0) SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
            else if(Phut == 0)
            {
                DestroyDynamicObject(GetPVarInt(giveplayerid, "objectMeatBBQ"));
                DestroyDynamicObject(GetPVarInt(giveplayerid, "objectFlameBBQ"));
                DeletePVar(giveplayerid, "objectMeatBBQ");
                DeletePVar(giveplayerid, "objectFlameBBQ");
                DeletePVar(giveplayerid, "orderBBQ");
                DeletePVar(giveplayerid, "onlineBBQ");
            }   
            else if(Giay == 0)
            {
                Phut--;
                Giay = 10;
                new count = 0;
                foreach(new j: Player)
                {
                    if(ProxDetectorObject(giveplayerid, j))
                    {  
                        count++;
                    }
                }
                foreach(new i: Player)
                {
                    new szbbqArray[128];
                    if(count > 2)
                    {
                        if(ProxDetectorObject(giveplayerid, i))
                        {
                            GivePlayerCash(i, 100000);
                            format(szbbqArray, sizeof szbbqArray, "{FF8000}* {C2A2DA}%s Cam thay thoai mai vi bua an.", GetPlayerNameEx(i));
                            SetPlayerChatBubble(i, szbbqArray, COLOR_PURPLE, 20.0, 5000);
                        }
                    }
                    else if(count <= 2)
                    {
                        if(ProxDetectorObject(giveplayerid, i))
                        {  
                            GivePlayerCash(i, 200000);
                            format(szbbqArray, sizeof szbbqArray, "{FF8000}* {C2A2DA}%s Cam thay thoai mai vi bua an.", GetPlayerNameEx(i));
                            SetPlayerChatBubble(i, szbbqArray, COLOR_PURPLE, 20.0, 5000);
                        }
                    }
                }
                SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
            }
        }
        case 2:
        {
            if(GetPVarInt(giveplayerid, "idlonuongBBQ") == -1)
            {
                Phut = 0;
                Giay = 0;
            }
            else if(GetPVarInt(giveplayerid, "MeatFlame") == 1)
            {
                DeletePVar(giveplayerid, "MeatFlame");
                SetPVarInt(giveplayerid, "objectMeatBBQ", CreateDynamicObject(2804, x, y, z+0.9, 0, 0, 0));
                SetPVarInt(giveplayerid, "objectFlameBBQ", CreateDynamicObject(18693, x, y+0.2, z-0.8, 0, 0, 0));
            }
            Giay--;
            format(string, sizeof(string), "Thoi Gian: {FFFFFF}%d:%d", Phut, Giay);
            UpdateDynamic3DTextLabelText(Text3D:GetPVarInt(giveplayerid, "text3dtimerBBQ"), COLOR_YELLOW, string);
            if(Giay > 0) SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
            else if(Phut == 0)
            {
                DestroyDynamicObject(GetPVarInt(giveplayerid, "objectMeatBBQ"));
                DestroyDynamicObject(GetPVarInt(giveplayerid, "objectFlameBBQ"));
                DeletePVar(giveplayerid, "objectMeatBBQ");
                DeletePVar(giveplayerid, "objectFlameBBQ");
                DeletePVar(giveplayerid, "orderBBQ");
                DeletePVar(giveplayerid, "onlineBBQ");
            }   
            else if(Giay == 0)
            {
                Phut--;
                Giay = 60;
                new count = 0;
                foreach(new j: Player)
                {
                    if(ProxDetectorObject(giveplayerid, j))
                    {  
                        count++;
                    }
                }
                foreach(new i: Player)
                {
                    new szbbqArray[128];
                    if(count > 6)
                    {
                        if(ProxDetectorObject(giveplayerid, i))
                        {
                            //GivePlayerHunger(i, 1000)
                            GivePlayerCash(i, 10);
                            format(szbbqArray, sizeof szbbqArray, "{FF8000}* {C2A2DA}%s Cam thay thoai mai vi bua an.", GetPlayerNameEx(i));
                            SetPlayerChatBubble(i, szbbqArray, COLOR_PURPLE, 20.0, 5000);
                        }
                    }
                    else if(count <= 6)
                    {
                        if(ProxDetectorObject(giveplayerid, i))
                        {
                            //GivePlayerHunger(i, 2000)
                            GivePlayerCash(i, 20);
                            format(szbbqArray, sizeof szbbqArray, "{FF8000}* {C2A2DA}%s Cam thay thoai mai vi bua an.", GetPlayerNameEx(i));
                            SetPlayerChatBubble(i, szbbqArray, COLOR_PURPLE, 20.0, 5000);
                        }
                    }
                }
                SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
            }
        }
        case 3:
        {
            if(GetPVarInt(giveplayerid, "idlonuongBBQ") == -1)
            {
                Phut = 0;
                Giay = 0;
            }
            else if(GetPVarInt(giveplayerid, "MeatFlame") == 1)
            {
                DeletePVar(giveplayerid, "MeatFlame");
                SetPVarInt(giveplayerid, "objectMeatBBQ", CreateDynamicObject(2804, x, y, z+0.9, 0, 0, 0));
                SetPVarInt(giveplayerid, "objectFlameBBQ", CreateDynamicObject(18693, x, y+0.2, z-0.8, 0, 0, 0));
            }
            Giay--;
            format(string, sizeof(string), "Thoi Gian: {FFFFFF}%d:%d", Phut, Giay);
            UpdateDynamic3DTextLabelText(Text3D:GetPVarInt(giveplayerid, "text3dtimerBBQ"), COLOR_YELLOW, string);
            if(Giay > 0) SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
            else if(Phut == 0)
            {
                DestroyDynamicObject(GetPVarInt(giveplayerid, "objectMeatBBQ"));
                DestroyDynamicObject(GetPVarInt(giveplayerid, "objectFlameBBQ"));
                DeletePVar(giveplayerid, "objectMeatBBQ");
                DeletePVar(giveplayerid, "objectFlameBBQ");
                DeletePVar(giveplayerid, "orderBBQ");
                DeletePVar(giveplayerid, "onlineBBQ");
            }   
            else if(Giay == 0)
            {
                Phut--;
                Giay = 60;
                new count = 0;
                foreach(new j: Player)
                {
                    if(ProxDetectorObject(giveplayerid, j))
                    {  
                        count++;
                    }
                }
                foreach(new i: Player)
                {
                    new szbbqArray[128];
                    if(count > 2)
                    {
                        if(ProxDetectorObject(giveplayerid, i))
                        {  
                            GivePlayerCash(i, 100000);
                            format(szbbqArray, sizeof szbbqArray, "{FF8000}* {C2A2DA}%s Cam thay thoai mai vi bua an.", GetPlayerNameEx(i));
                            SetPlayerChatBubble(i, szbbqArray, COLOR_PURPLE, 20.0, 5000);
                        }
                    }
                    else if(count <= 2)
                    {
                        if(ProxDetectorObject(giveplayerid, i))
                        {  
                            GivePlayerCash(i, 200000);
                            format(szbbqArray, sizeof szbbqArray, "{FF8000}* {C2A2DA}%s Cam thay thoai mai vi bua an.", GetPlayerNameEx(i));
                            SetPlayerChatBubble(i, szbbqArray, COLOR_PURPLE, 20.0, 5000);
                        }
                    }
                }
                SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
            }
        }
    }
}

hook OnPlayerEnterCheckpoint(playerid)
{
    new loaithit = GetPVarInt(playerid, "loaithitBBQ");
    new giveplayerid = GetPVarInt(playerid, "idorderBBQ");
    new Phut, Giay;
    if(GetPVarInt(playerid, "receiveBBQ") == 1)
    {
        if(GetPVarInt(playerid, "shipBBQ") == 1)
        {
            DeletePVar(playerid, "shipBBQ");
            DisablePlayerCheckpoint(playerid);
            SendClientMessageEx(playerid, COLOR_WHITE, "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Su dung lenh /layhangbbq [ id ] de lay loai thit ma khach hang muon.");
            SendClientMessageEx(playerid, COLOR_WHITE, "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Hay dung phia sau thung xe de co the lay hang.");
        }
        if(GetPVarInt(giveplayerid, "onlineBBQ") == 0)
        {
            switch(loaithit)
            {
                case 1:
                {
                    Phut = 2;
                    Giay = 10;
                    SetPVarInt(giveplayerid, "MeatFlame", 1);
                    SetPVarInt(giveplayerid, "onlineBBQ", 1);
                    DeletePVar(giveplayerid, "orderBBQ");
                    DeletePVar(playerid, "receiveBBQ");
                    DeletePVar(playerid, "loaithitBBQ");
                    DisablePlayerCheckpoint(playerid);
                    ClearAnimations(playerid);
                    RemovePlayerAttachedObject(playerid, 0);
                    SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
                }
                case 2:
                {
                    Phut = 10;
                    Giay = 60;
                    SetPVarInt(giveplayerid, "MeatFlame", 1);
                    SetPVarInt(giveplayerid, "onlineBBQ", 1);
                    DeletePVar(giveplayerid, "orderBBQ");
                    DeletePVar(playerid, "receiveBBQ");
                    DeletePVar(playerid, "loaithitBBQ");
                    DisablePlayerCheckpoint(playerid);
                    ClearAnimations(playerid);
                    RemovePlayerAttachedObject(playerid, 0);
                    SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
                }
                case 3:
                {
                    Phut = 15;
                    Giay = 60;
                    SetPVarInt(giveplayerid, "MeatFlame", 1);
                    SetPVarInt(giveplayerid, "onlineBBQ", 1);
                    DeletePVar(giveplayerid, "orderBBQ");
                    DeletePVar(playerid, "receiveBBQ");
                    DeletePVar(playerid, "loaithitBBQ");
                    DisablePlayerCheckpoint(playerid);
                    ClearAnimations(playerid);
                    RemovePlayerAttachedObject(playerid, 0);
                    SetTimerEx("StartLoNuongBBQ", 1000, false, "iiii", giveplayerid, loaithit, Phut, Giay);
                }
            }
        }
        else SendClientMessageEx(playerid, COLOR_WHITE, "Lo Nuong BBQ dang hoat dong, ban khong the nuong them thit.");
    }
    else if(GetPVarInt(playerid, "receiveBBQ") == 0)
    {
        new string[128];
        format(string, sizeof(string), "{00FF00}[HOUSE-SYSTEM] {FFFFFF}[ID:%d] %s tai can ho [HOUSE: %d] {FF3333}Da huy don dat hang.", giveplayerid, GetPlayerNameEx(giveplayerid), PlayerInfo[giveplayerid][pPhousekey]);
        SendClientMessageEx(playerid, COLOR_WHITE, string);
    }

}

hook OnPlayerDisconnect(playerid)
{
    if(GetPVarType(playerid, "objectBBQ"))
    {
        DestroyDynamicObject(GetPVarInt(playerid, "objectBBQ"));
        DestroyDynamicObject(GetPVarInt(playerid, "objectMeatBBQ"));
        DestroyDynamicObject(GetPVarInt(playerid, "objectFlameBBQ"));
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "text3dnameBBQ"));
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "text3dtimerBBQ"));
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "text3ddestroyBBQ"));
        DeletePVar(playerid, "objectBBQ");
        DeletePVar(playerid, "text3dnameBBQ");
        DeletePVar(playerid, "text3dtimerBBQ");
        DeletePVar(playerid, "text3ddestroyBBQ");
        DeletePVar(playerid, "objectMeatBBQ");
        DeletePVar(playerid, "objectFlameBBQ");
        DeletePVar(playerid, "lonuongBBQX");
        DeletePVar(playerid, "lonuongBBQY");
        DeletePVar(playerid, "lonuongBBQZ");
        DeletePVar(playerid, "orderBBQ");
        DeletePVar(playerid, "idlonuongBBQ");
        DeletePVar(playerid, "onlineBBQ");
        DeletePVar(playerid, "MeatFlame");
        DeletePVar(playerid, "iddeliverBBQ");
        DeletePVar(playerid, "receiveBBQ");
    }
    return 1;
}

CMD:placebbq(playerid, params[])
{
    if(GetPVarType(playerid, "objectBBQ")) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban da dat mot LO NUONG BBQ, su dung /destroybbq.");
    if(Homes[playerid] >= 0)
	{
        new string[128];
        //new rand = random(100);
        new Float:x, Float:y, Float:z, Float:a;
        new Phut, Giay;

        foreach(new i: Player)
	    {
	        if(GetPVarType(i, "idlonuongBBQ"))
	        {
    			if(IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(i, "lonuongBBQX"), GetPVarFloat(i, "lonuongBBQY"), GetPVarFloat(i, "lonuongBBQZ")))
				{
				    SendClientMessage(playerid, COLOR_WHITE, "Ban dang o trong pham vi cua mot Lo Nuong BBQ khac, ban khong the dat mot Lo Nuong BBQ o day!");
				    return 1;
				}
			}
		}
		for(new i; i < MAX_HOUSES; i++)
		{
            switch(HouseInfo[i][hLevel])
            {
                case 1:
                {
                    if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 15.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW])))
                    {
                        format(string, sizeof(string), "%s' dat LO NUONG BBQ!", GetPlayerNameEx(playerid));
                        ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
                        
                        GetPlayerPos(playerid, x, y, z);
                        GetPlayerFacingAngle(playerid, a);
                        ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
                        x += (2 * floatsin(-a, degrees));
                        y += (2 * floatcos(-a, degrees));
                        z -= 1.0;
                        
                        SetPVarInt(playerid, "idlonuongBBQ", playerid);
                        SetPVarInt(playerid, "objectBBQ", CreateDynamicObject(19831, x, y, z, 0.0, 0.0, a));
                        SetPVarFloat(playerid, "lonuongBBQX", x); SetPVarFloat(playerid, "lonuongBBQY", y); SetPVarFloat(playerid, "lonuongBBQZ", z);
                        format(string, sizeof(string), "BBQ: {FFFFFF}%s [%d]", GetPlayerNameEx(playerid), GetPVarInt(playerid, "idlonuongBBQ"));
                        SetPVarInt(playerid, "text3dnameBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.7, 20.0));
                        format(string, sizeof(string), "Thoi Gian: {FFFFFF}%d:%d", Phut, Giay);
                        SetPVarInt(playerid, "text3dtimerBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.6, 20.0));
                        format(string, sizeof(string), "{FFFFFF}/destroybbq");
                        SetPVarInt(playerid, "text3ddestroyBBQ", _:CreateDynamic3DTextLabel(string, COLOR_TWWHITE, x, y, z+0.5, 20.0));
                        return 1;
                    }
                }
                case 2:
                {
                    if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 15.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW])))
                    {
                        format(string, sizeof(string), "%s' dat LO NUONG BBQ!", GetPlayerNameEx(playerid));
                        ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
                        
                        GetPlayerPos(playerid, x, y, z);
                        GetPlayerFacingAngle(playerid, a);
                        ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
                        x += (2 * floatsin(-a, degrees));
                        y += (2 * floatcos(-a, degrees));
                        z -= 1.0;
                        
                        SetPVarInt(playerid, "idlonuongBBQ", playerid);
                        SetPVarInt(playerid, "objectBBQ", CreateDynamicObject(19831, x, y, z, 0.0, 0.0, a));
                        SetPVarFloat(playerid, "lonuongBBQX", x); SetPVarFloat(playerid, "lonuongBBQY", y); SetPVarFloat(playerid, "lonuongBBQZ", z);
                        format(string, sizeof(string), "BBQ: {FFFFFF}%s [%d]", GetPlayerNameEx(playerid), GetPVarInt(playerid, "idlonuongBBQ"));
                        SetPVarInt(playerid, "text3dnameBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.7, 20.0));
                        format(string, sizeof(string), "Thoi Gian: {FFFFFF}%d:%d", Phut, Giay);
                        SetPVarInt(playerid, "text3dtimerBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.6, 20.0));
                        format(string, sizeof(string), "{FFFFFF}/destroybbq");
                        SetPVarInt(playerid, "text3ddestroyBBQ", _:CreateDynamic3DTextLabel(string, COLOR_TWWHITE, x, y, z+0.5, 20.0));
                        return 1;
                    }
                }
                case 3:
                {
                    if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 15.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW])))
                    {
                        format(string, sizeof(string), "%s' dat LO NUONG BBQ!", GetPlayerNameEx(playerid));
                        ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
                        
                        GetPlayerPos(playerid, x, y, z);
                        GetPlayerFacingAngle(playerid, a);
                        ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
                        x += (2 * floatsin(-a, degrees));
                        y += (2 * floatcos(-a, degrees));
                        z -= 1.0;
                        
                        SetPVarInt(playerid, "idlonuongBBQ", playerid);
                        SetPVarInt(playerid, "objectBBQ", CreateDynamicObject(19831, x, y, z, 0.0, 0.0, a));
                        SetPVarFloat(playerid, "lonuongBBQX", x); SetPVarFloat(playerid, "lonuongBBQY", y); SetPVarFloat(playerid, "lonuongBBQZ", z);
                        format(string, sizeof(string), "BBQ: {FFFFFF}%s [%d]", GetPlayerNameEx(playerid), GetPVarInt(playerid, "idlonuongBBQ"));
                        SetPVarInt(playerid, "text3dnameBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.7, 20.0));
                        format(string, sizeof(string), "Thoi Gian: {FFFFFF}%d:%d", Phut, Giay);
                        SetPVarInt(playerid, "text3dtimerBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.6, 20.0));
                        format(string, sizeof(string), "{FFFFFF}/destroybbq");
                        SetPVarInt(playerid, "text3ddestroyBBQ", _:CreateDynamic3DTextLabel(string, COLOR_TWWHITE, x, y, z+0.5, 20.0));
                        return 1;
                    }
                }
                case 4:
                {
                    if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 15.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW])))
                    {
                        format(string, sizeof(string), "%s' dat LO NUONG BBQ!", GetPlayerNameEx(playerid));
                        ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
                        
                        GetPlayerPos(playerid, x, y, z);
                        GetPlayerFacingAngle(playerid, a);
                        ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
                        x += (2 * floatsin(-a, degrees));
                        y += (2 * floatcos(-a, degrees));
                        z -= 1.0;
                        
                        SetPVarInt(playerid, "idlonuongBBQ", playerid);
                        SetPVarInt(playerid, "objectBBQ", CreateDynamicObject(19831, x, y, z, 0.0, 0.0, a));
                        SetPVarFloat(playerid, "lonuongBBQX", x); SetPVarFloat(playerid, "lonuongBBQY", y); SetPVarFloat(playerid, "lonuongBBQZ", z);
                        format(string, sizeof(string), "BBQ: {FFFFFF}%s [%d]", GetPlayerNameEx(playerid), GetPVarInt(playerid, "idlonuongBBQ"));
                        SetPVarInt(playerid, "text3dnameBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.7, 20.0));
                        format(string, sizeof(string), "Thoi Gian: {FFFFFF}%d:%d", Phut, Giay);
                        SetPVarInt(playerid, "text3dtimerBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.6, 20.0));
                        format(string, sizeof(string), "{FFFFFF}/destroybbq");
                        SetPVarInt(playerid, "text3ddestroyBBQ", _:CreateDynamic3DTextLabel(string, COLOR_TWWHITE, x, y, z+0.5, 20.0));
                        return 1;
                    }
                }
                case 5:
                {
                    if(GetPlayerSQLId(playerid) == HouseInfo[i][hOwnerID] && ((IsPlayerInRangeOfPoint(playerid, 15.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW])))
                    {
                        format(string, sizeof(string), "%s' dat LO NUONG BBQ!", GetPlayerNameEx(playerid));
                        ProxDetector(30.0, playerid, string, COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
                        
                        GetPlayerPos(playerid, x, y, z);
                        GetPlayerFacingAngle(playerid, a);
                        ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
                        x += (2 * floatsin(-a, degrees));
                        y += (2 * floatcos(-a, degrees));
                        z -= 1.0;
                        
                        SetPVarInt(playerid, "idlonuongBBQ", playerid);
                        SetPVarInt(playerid, "objectBBQ", CreateDynamicObject(19831, x, y, z, 0.0, 0.0, a));
                        SetPVarFloat(playerid, "lonuongBBQX", x); SetPVarFloat(playerid, "lonuongBBQY", y); SetPVarFloat(playerid, "lonuongBBQZ", z);
                        format(string, sizeof(string), "BBQ: {FFFFFF}%s [%d]", GetPlayerNameEx(playerid), GetPVarInt(playerid, "idlonuongBBQ"));
                        SetPVarInt(playerid, "text3dnameBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.7, 20.0));
                        format(string, sizeof(string), "Thoi Gian: {FFFFFF}%d:%d", Phut, Giay);
                        SetPVarInt(playerid, "text3dtimerBBQ", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, x, y, z+0.6, 20.0));
                        format(string, sizeof(string), "{FFFFFF}/destroybbq");
                        SetPVarInt(playerid, "text3ddestroyBBQ", _:CreateDynamic3DTextLabel(string, COLOR_TWWHITE, x, y, z+0.5, 20.0));
                        return 1;
                    }
                }
            }
		}
        SendClientMessageEx(playerid, COLOR_GREY, "Ban can phai dung gan can nha");
	}
	else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong so huu nha nao.");
    return 1;
}

CMD:destroybbq(playerid, params[])
{
    if(GetPVarInt(playerid, "onlineBBQ") == 1) return SendClientMessage(playerid, COLOR_WHITE, "Lo Nuong BBQ dang hoat dong, ban khong the xoa");
    else if(GetPVarInt(playerid, "orderBBQ") == 1) return SendClientMessage(playerid, COLOR_WHITE, "Ban da goi dich vu giao thit BBQ, su dung /huydichvubbq ");
    if(GetPVarInt(playerid, "objectBBQ") != 0)
    {
        DestroyDynamicObject(GetPVarInt(playerid, "objectBBQ"));
        DestroyDynamicObject(GetPVarInt(playerid, "objectMeatBBQ"));
        DestroyDynamicObject(GetPVarInt(playerid, "objectFlameBBQ"));
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "text3dnameBBQ"));
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "text3dtimerBBQ"));
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "text3ddestroyBBQ"));
        DeletePVar(playerid, "objectBBQ");
        DeletePVar(playerid, "text3dnameBBQ");
        DeletePVar(playerid, "text3dtimerBBQ");
        DeletePVar(playerid, "text3ddestroyBBQ");
        DeletePVar(playerid, "objectMeatBBQ");
        DeletePVar(playerid, "objectFlameBBQ");
        DeletePVar(playerid, "lonuongBBQX");
        DeletePVar(playerid, "lonuongBBQY");
        DeletePVar(playerid, "lonuongBBQZ");
        DeletePVar(playerid, "orderBBQ");
        DeletePVar(playerid, "idlonuongBBQ");
        DeletePVar(playerid, "onlineBBQ");
        DeletePVar(playerid, "MeatFlame");
        SendClientMessage(playerid, COLOR_WHITE, "Ban da xoa LO NUONG BBQ!");
    }
    else return SendClientMessage(playerid, COLOR_WHITE, "Ban chua dat LO NUONG BBQ!");
    return 1;
}

CMD:dichvugiaohangbbq(playerid, params[])
{
    if(GetPVarInt(playerid, "orderBBQ") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban da dat don hang giao thit BBQ tu truoc!");
    else if(GetPVarInt(playerid, "onlineBBQ") == 1) return SendClientMessageEx(playerid, COLOR_GREY, "Lo Nuong BBQ dang con thit, ban khong the dat them hang vao luc nay!");
    else if(GetPVarInt(playerid, "idlonuongBBQ") >= 0)
    {
        new string[128];
        new iHouseID;
        //new i = PlayerInfo[playerid][pPhousekey], j = PlayerInfo[playerid][pPhousekey2];
        for(new i; i < MAX_HOUSES; i++)
        {
            if(i == PlayerInfo[playerid][pPhousekey] && (IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]))
            {
                iHouseID = i;
                break;
            }
            else if(i == PlayerInfo[playerid][pPhousekey2] && (IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]))
            {
                iHouseID = i;
                break;
            }
            else if(i == PlayerInfo[playerid][pPhousekey3] && (IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[i][hExteriorX], HouseInfo[i][hExteriorY], HouseInfo[i][hExteriorZ]) && GetPlayerVirtualWorld(playerid) == HouseInfo[i][hExtVW] && GetPlayerInterior(playerid) == HouseInfo[i][hExtIW]))
            {
                iHouseID = i;
                break;
            }
        }

        if(iHouseID == PlayerInfo[playerid][pPhousekey] && (IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(playerid, "lonuongBBQX"), GetPVarFloat(playerid, "lonuongBBQY"), GetPVarFloat(playerid, "lonuongBBQZ")))) {
            SetPVarInt(playerid, "orderBBQ", 1);
            SendClientMessageEx(playerid, COLOR_WHITE, "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Ban vua yeu cau mot don hang giao thit bbq den nha cua ban");
            format(string, sizeof(string), "{00FF00}[HOUSE-SYSTEM] {FFFFFF}[ID:%d] %s' tai can ho [HOUSE: %d] vua yeu cau mot don hang thit nuong.", playerid, GetPlayerNameEx(playerid), PlayerInfo[playerid][pPhousekey]);
            SendBBQMessage(20, TEAM_AZTECAS_COLOR, string);
            SendBBQMessage(21, TEAM_AZTECAS_COLOR, string);
            format(string, sizeof(string), "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Su dung: /chapnhangiaohangbbq [playerid].");
            SendBBQMessage(20, TEAM_AZTECAS_COLOR, string);
            SendBBQMessage(21, TEAM_AZTECAS_COLOR, string);
            return 1;
        }
        else if(iHouseID == PlayerInfo[playerid][pPhousekey2] && (IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(playerid, "lonuongBBQX"), GetPVarFloat(playerid, "lonuongBBQY"), GetPVarFloat(playerid, "lonuongBBQZ")))) {
            SetPVarInt(playerid, "orderBBQ", 1);
            SendClientMessageEx(playerid, COLOR_WHITE, "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Ban vua yeu cau mot don hang giao thit bbq den nha cua ban");
            format(string, sizeof(string), "{00FF00}[HOUSE-SYSTEM] {FFFFFF}[ID:%d] %s' tai can ho [HOUSE: %d] vua yeu cau mot don hang thit nuong.", playerid, GetPlayerNameEx(playerid), PlayerInfo[playerid][pPhousekey2]);
            SendBBQMessage(20, TEAM_AZTECAS_COLOR, string);
            SendBBQMessage(21, TEAM_AZTECAS_COLOR, string);
            format(string, sizeof(string), "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Su dung: /chapnhangiaohangbbq [playerid].");
            SendBBQMessage(20, TEAM_AZTECAS_COLOR, string);
            SendBBQMessage(21, TEAM_AZTECAS_COLOR, string);
            return 1;
        }
        else if(iHouseID == PlayerInfo[playerid][pPhousekey3] && (IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(playerid, "lonuongBBQX"), GetPVarFloat(playerid, "lonuongBBQY"), GetPVarFloat(playerid, "lonuongBBQZ")))) {
            SetPVarInt(playerid, "orderBBQ", 1);
            SendClientMessageEx(playerid, COLOR_WHITE, "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Ban vua yeu cau mot don hang giao thit bbq den nha cua ban");
            format(string, sizeof(string), "{00FF00}[HOUSE-SYSTEM] {FFFFFF}[ID:%d] %s' tai can ho [HOUSE: %d] vua yeu cau mot don hang thit nuong.", playerid, GetPlayerNameEx(playerid), PlayerInfo[playerid][pPhousekey3]);
            SendBBQMessage(20, TEAM_AZTECAS_COLOR, string);
            SendBBQMessage(21, TEAM_AZTECAS_COLOR, string);
            format(string, sizeof(string), "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Su dung: /chapnhangiaohangbbq [playerid].");
            SendBBQMessage(20, TEAM_AZTECAS_COLOR, string);
            SendBBQMessage(21, TEAM_AZTECAS_COLOR, string);
            return 1;
        }
        else return SendClientMessage(playerid, COLOR_WHITE, "Ban can dung gan ngoi nha da (/placebbq) de su dung, /dichvugiaohangbbq");
    }
    else SendClientMessage(playerid, COLOR_WHITE, "Ban chua dat LO NUONG BBQ! - /placebbq");
    return 1;
}

CMD:huydichvubbq(playerid, params[])
{
    new iddeliver = GetPVarInt(playerid, "iddeliverBBQ");
    new string[128];
    if(GetPVarInt(playerid, "orderBBQ") == 1)
    {
        DisablePlayerCheckpoint(iddeliver);
        DeletePVar(iddeliver, "receiveBBQ");
        DeletePVar(playerid, "orderBBQ");
        DeletePVar(iddeliver, "shipBBQ");
        SendClientMessageEx(playerid, COLOR_WHITE, "{00FF00}[HOUSE-SYSTEM] {FFFFFF}Ban vua huy yeu cau mot don hang giao thit bbq den nha cua ban");
        format(string, sizeof(string), "{00FF00}[HOUSE-SYSTEM] {FFFFFF}[ID:%d] %s tai can ho [HOUSE: %d] {FF3333}Vua huy yeu cau mot don hang thit nuong.", playerid, GetPlayerNameEx(playerid), PlayerInfo[playerid][pPhousekey]);
        SendBBQMessage(20, TEAM_AZTECAS_COLOR, string);
        return 1;
    }
    SendClientMessage(playerid, COLOR_RED, "Ban chua goi dich vu giao hang BBQ lan nao, su dung /dichvugiaohangbbq");
    return 1;
}

CMD:chapnhangiaohangbbq(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob] == 21 || PlayerInfo[playerid][pJob2] == 21)
    {
        new giveplayerid;
        new string[128];
        if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /chapnhangiaohang [playerid]");
        if(playerid == giveplayerid) return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the chap nhan don hang giao thit BBQ cho chinh minh");
        if(GetPVarInt(giveplayerid, "orderBBQ") != 1) return SendClientMessageEx(playerid, COLOR_GREY, "Nguoi choi nay chua dat hang giao thit BBQ");
        if(IsPlayerConnected(giveplayerid))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(IsAPizzaCar(vehicleid) || IsATruckerCar(vehicleid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
                if(!CheckPointCheck(playerid))
                {
                    if(GetPVarInt(playerid, "receiveBBQ") > 0)
                    {
                        SendClientMessageEx(playerid, COLOR_WHITE, "Ban dang nhan mot don hang giao thit BBQ, su dung /huygiaohangbbq de huy giao thit BBQ");
                        return 1;
                    }
                    SetPVarInt(playerid, "idorderBBQ", giveplayerid);
                    SetPVarInt(playerid, "receiveBBQ", 1);
                    SetPVarInt(playerid, "shipBBQ", 1);
                    SetPVarInt(playerid, "iddeliverBBQ", playerid);
                    SetPlayerCheckpoint(playerid, GetPVarFloat(giveplayerid, "lonuongBBQX"), GetPVarFloat(giveplayerid, "lonuongBBQY"), GetPVarFloat(giveplayerid, "lonuongBBQZ"), 10.0);
                    format(string, sizeof(string), "{00FF00}[Giao Hang] {FFFFFF}Hay di theo checkpoint den vi tri nha cua %s", GetPlayerNameEx(giveplayerid));
                    SendClientMessageEx(playerid, COLOR_WHITE, string);
                }
                else return SendClientMessageEx(playerid, COLOR_WHITE, "Xin hay chac chan rang cac diem checkpoint cua ban da bi xoa bo.");
            }
            else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong lai xe Trucker hoac Pizza yeu cau!");
        }
        else SendClientMessageEx(playerid, COLOR_GRAD1, "Nguoi choi khong hop le.");
    }
    else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai Nguoi Dua Hang hoac Giao Pizza!");
	return 1;
}

CMD:layhangbbq(playerid, params[])
{
    new loaithit;
    new giveplayerid;
    new string[128];
	if(sscanf(params, "d", loaithit))
	{
		SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /layhangbbq [loaithit]\nCo san: 1, 2, 3");
		return 1;
	}
    if(loaithit < 1 || loaithit > 3) return SendClientMessageEx(playerid, COLOR_GREY, "SU DUNG: /layhangbbq [loaithit]\nCo san: 1, 2, 3");
    if(GetPVarInt(playerid, "receiveBBQ") != 1) return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can nhan hoac hoan thanh giao thit BBQ moi co the /layhangbbq tiep tuc");
    else if(GetPVarInt(playerid, "receiveBBQ") == 1)
    {
        if(!IsPlayerInAnyVehicle(playerid))
		{
			new closestcar = GetClosestCar(playerid);
			if(IsPlayerInRangeOfVehicle(playerid, closestcar, 3.0))
			{
				if(GetVehicleModel(closestcar) == 481 || GetVehicleModel(closestcar) == 509 || GetVehicleModel(closestcar) == 510)
				{
					return SendClientMessageEx(playerid,COLOR_WHITE,"Lenh nay khong the duoc su dung trong chiec xe nay.");
				}
				SetPVarInt(playerid, "loaithitBBQ", loaithit);
                giveplayerid = GetPVarInt(playerid, "idorderBBQ");
                switch(loaithit)
                {
                    case 1:
                    {
                        ApplyAnimation(playerid, "CARRY", "CRRY_PRTIAL", 4.1, 0, 0, 0, 1, 1, 1);
                        SetPlayerAttachedObject(playerid, 0, 19560, 6, 0.0920, -0.0190, -0.1509, -102.5001, -5.6000, -104.5998, 1.2330, 1.1090, 1.8500, 0xFFFFFFFF, 0xFFFFFFFF);
                        SetPlayerCheckpoint(playerid, GetPVarFloat(giveplayerid, "lonuongBBQX"), GetPVarFloat(giveplayerid, "lonuongBBQY"), GetPVarFloat(giveplayerid, "lonuongBBQZ"), 4.0);
                    }
                    case 2:
                    {
                        ApplyAnimation(playerid, "CARRY", "CRRY_PRTIAL", 4.1, 0, 0, 0, 1, 1, 1);
                        SetPlayerAttachedObject(playerid, 0, 2805, 1, 0.0829, 0.4129, 0.0000, 0.0000, 19.9000, 0.0000, 0.6320, 0.7900, 0.5670, 0xFFFFFFFF, 0xFFFFFFFF);
                        SetPlayerCheckpoint(playerid, GetPVarFloat(giveplayerid, "lonuongBBQX"), GetPVarFloat(giveplayerid, "lonuongBBQY"), GetPVarFloat(giveplayerid, "lonuongBBQZ"), 4.0);
                    }
                    case 3:
                    {
                        ApplyAnimation(playerid, "CARRY", "CRRY_PRTIAL", 4.1, 0, 0, 0, 1, 1, 1);
                        SetPlayerAttachedObject(playerid, 0, 2803, 1, 0.1060, 0.4039, 0.0000, 0.0000, 94.9000, 0.0000, 0.4400, 0.6770, 0.4000, 0xFFFFFFFF, 0xFFFFFFFF);
                        SetPlayerCheckpoint(playerid, GetPVarFloat(giveplayerid, "lonuongBBQX"), GetPVarFloat(giveplayerid, "lonuongBBQY"), GetPVarFloat(giveplayerid, "lonuongBBQZ"), 4.0);
                    }
                }
                format(string, sizeof(string), "{00FF00}[Giao Hang] {FFFFFF}Hay di den checkpoint Lo Nuong BBQ ID:%d", GetPVarInt(giveplayerid, "idlonuongBBQ"));
                SendClientMessageEx(playerid, COLOR_WHITE, string);
			}
            else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can dung gan xe Tai hoac Pizza moi co the /layhangbbq [loaithit]");
		}
        else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can ra khoi xe moi co the /layhangbbq [loaithit]");
    }
    else return SendClientMessageEx(playerid, COLOR_WHITE, "Ban can hoan thanh giao thit BBQ moi co the /layhangbbq tiep tuc");
    return 1;
}

CMD:huygiaohangbbq(playerid, params[])
{
    if(PlayerInfo[playerid][pJob] == 20 || PlayerInfo[playerid][pJob2] == 20 || PlayerInfo[playerid][pJob] == 21 || PlayerInfo[playerid][pJob2] == 21)
    {
        if(GetPVarInt(playerid, "receiveBBQ") != 1) return SendClientMessageEx(playerid, COLOR_GREY, "Ban chua chap nhan don hang giao thit BBQ nao ca!");
        if(GetPVarInt(playerid, "receiveBBQ") == 1)
        {
            DisablePlayerCheckpoint(playerid);
            DeletePVar(playerid, "receiveBBQ");
            DeletePVar(playerid, "loaithitBBQ");
            SendClientMessageEx(playerid, COLOR_WHITE, "Ban da huy don hang giao thit BBQ, co the /chapnhangiaothitbbq [id]");
        }
    }
    else return SendClientMessageEx(playerid, COLOR_GREY, "Ban khong phai Nguoi Dua Hang hoac Giao Pizza!");
	return 1;
}