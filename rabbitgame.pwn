//RGAME.NETWORK
//KELVIN

#include <a_samp>
#include <YSI_Coding\y_hooks>
#include <YSI_Data\y_iterate>
#include <streamer>
#include <Pawn.CMD>

#define         MAX_OBJECTRBG       44
#define         MAX_TEAMRBG         10

new PlayerText:RabbitTable[MAX_PLAYERS];
new PlayerText:RabbitClickO[MAX_PLAYERS];

enum info_RBG
{
    idobject_RBG,
    object_RBG,
    rd_ObjectRBG,
}

enum rbgInfo
{
    rbgMember,
    TEAM,
    POINTS,
}

enum RBGData
{
    POINTS,
}

new stock
    arrTeamRBG[MAX_TEAMRBG][RBGData],
    iObjectRBG[MAX_OBJECTRBG][info_RBG],
    PlayerInfoRBG[MAX_PLAYERS][rbgInfo];

new RBG_ObjectMap[50];

new
    Money_RBG,
    itotalRB,
    OnRBNPC,
    RabbitiCount,
    RabbitONPC,
    RBG_TimerRoundOne,
    RBG_TimerRoundThree,
    RabbitRangeOne,
    RBG_ShowInfoGame,
    RBG_ShowInfoGameThree,
    Join_RBG;

hook OnGameModeInit()
{   
    new strtrbg[128];
    RBG_ObjectMap[0] = CreateDynamicObject(-20088, 3578.2758, 1791.5404, 138.9089, 0.0000, 0.0000, 0.0000, .drawdistance = 500, .streamdistance = 500);//object new
    RBG_ObjectMap[1] = CreateDynamicObject(-20087, 3579.1867, 1576.7272, 138.9089, 0.0000, 0.0000, 0.0000, .drawdistance = 500, .streamdistance = 500);//object new
    RBG_ObjectMap[2] = CreateDynamicObject(-20086, 3579.1867, 1576.7142, 138.9089, 0.0000, 0.0000, 0.0000, .drawdistance = 500, .streamdistance = 500);//object new
    RBG_ObjectMap[3] = CreateDynamicObject(845, 3577.257568, 1895.326049, 145.375839, -34.699851, 95.299858, 86.399864, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ObjectMap[4] = CreateDynamicObject(839, 3576.098144, 1895.669799, 140.359176, 0.0, 0.0, 0.0, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ObjectMap[5] = CreateDynamicObject(839, 3579.502441, 1895.609741, 140.269210, 0.0, 0.0, 68.099815, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ObjectMap[6] = CreateDynamicObject(844, 3576.145507, 1894.804321, 145.210556, -62.899929, -11.299957, -164.701004, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ObjectMap[7] = CreateDynamicObject(4597, 3558.112304, 1561.221801, 138.629547, 0.0, 0.0, 0.0, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ObjectMap[8] = CreateDynamicObject(4597, 3598.466064, 1561.230590, 138.619598, 0.0, 0.0, 0.0, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ObjectMap[9] = CreateDynamicObject(4597, 3598.466064, 1885.230590, 138.619598, 0.0, 0.0, 0.0, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ObjectMap[10] = CreateDynamicObject(4597, 3558.112304, 1885.230590, 138.619598, 0.0, 0.0, 0.0, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ObjectMap[11] = CreateDynamicObject(3571, 3566.0134, 1890.1000, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[12] = CreateDynamicObject(3571, 3566.0134, 1882.0152, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[13] = CreateDynamicObject(3571, 3568.5458, 1882.0152, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[14] = CreateDynamicObject(3571, 3568.5458, 1890.1000, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[15] = CreateDynamicObject(3571, 3568.5458, 1873.9396, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[16] = CreateDynamicObject(3571, 3566.0134, 1873.9396, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[17] = CreateDynamicObject(8613, 3569.7412, 1898.2803, 143.2721, 0.0000, 0.0000, 180.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //vgsSstairs03_lvs
    RBG_ObjectMap[18] = CreateDynamicObject(3571, 3587.9892, 1890.0999, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[19] = CreateDynamicObject(3571, 3587.9892, 1882.0241, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[20] = CreateDynamicObject(3571, 3590.5124, 1890.0963, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[21] = CreateDynamicObject(3571, 3587.9892, 1873.9488, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[22] = CreateDynamicObject(3571, 3590.5124, 1873.9488, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[23] = CreateDynamicObject(3571, 3590.5124, 1882.0332, 145.2978, 0.0000, 0.0000, 90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[24] = CreateDynamicObject(8613, 3591.7219, 1898.2805, 143.2721, 0.0000, 0.0000, 180.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //vgsSstairs03_lvs
    RBG_ObjectMap[25] = CreateDynamicObject(3571, 3595.8229, 1882.0241, 145.2978, 0.0000, 0.0000, 0.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[26] = CreateDynamicObject(3571, 3603.8989, 1882.0241, 145.2978, 0.0000, 0.0000, 0.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[27] = CreateDynamicObject(3571, 3560.6784, 1882.0152, 145.2978, 0.0000, 0.0000, 0.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[28] = CreateDynamicObject(3571, 3552.6005, 1882.0152, 145.2978, 0.0000, 0.0000, 0.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[29] = CreateDynamicObject(3571, 3544.5229, 1882.0152, 145.2978, 0.0000, 0.0000, 0.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3
    RBG_ObjectMap[30] = CreateDynamicObject(3571, 3611.9763, 1882.0241, 145.2978, 0.0000, 0.0000, 0.0000, 3, 0, .drawdistance = 500, .streamdistance = 500); //lasdkrt3

    RabbitRangeOne = CreateDynamicObject(3556, 3578.695068, 1930.526123, 141.529159, 0.0, 0.0, 180.0, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RabbitONPC = CreateDynamicObject(-20089, 3577.308593, 1890.537597, 137.339859, 0.0, 0.0, -36.500015, 1, 0, .drawdistance = 500, .streamdistance = 500);//object new
    RBG_TimerRoundOne = CreateDynamicObject(4735, 3552.635009, 1928.639892, 150.788726, 0.0, 0.0, 90.0, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ShowInfoGame = CreateDynamicObject(4731, 3578.315673, 1479.386230, 149.148605, 0.0, 0.0, 30.300069, 1, 0, .drawdistance = 500, .streamdistance = 500);
    RBG_ShowInfoGameThree = CreateDynamicObject(4735, 3578.1391, 1838.6629, 155.2195, 0.0000, 0.0000, -90.0000, 3, 0, .drawdistance = 500, .streamdistance = 500);
    format(strtrbg, sizeof(strtrbg), "Tro Choi Con Tho\n\n0\n\n$0\n\nRGAME.NETWORK");
    SetDynamicObjectMaterialText(RBG_ShowInfoGame, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 50, 1, 0xFF00FF00, 1, 1);
    format(strtrbg, sizeof(strtrbg), "0:0");
    SetDynamicObjectMaterialText(RBG_TimerRoundOne, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 255, 1, 0xFF00FF00, 1, 1);
    format(strtrbg, sizeof(strtrbg), "0:0\nTeam 1: 0\nTeam 2: 0");
    SetDynamicObjectMaterialText(RBG_ShowInfoGameThree, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 100, 1, 0xFF00FF00, 1, 1);
    SetTimer("CheckObjectGuongRBG", 500, true);
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
    if(playertextid == RabbitClickO[playerid])
    {
        new iteamrbg = PlayerInfoRBG[playerid][TEAM];
        arrTeamRBG[iteamrbg][POINTS]++;        
        PlayerTextDrawDestroy(playerid, RabbitClickO[playerid]);
        ShowTextClick(playerid);
        return 1;
    }
    return 0;
}

hook OnPlayerUpdate(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    if(GetPVarInt(playerid, "iMoveRabbit") == 1)
    {
        if(x != GetPVarFloat(playerid, "iCureentPos"))
        {
            OnPlayerChangePos(playerid, GetPVarFloat(playerid, "iCurrentPos"), x);
        }
        SetPVarFloat(playerid, "iCurrentPos", x);
    }
    return 1;
}

hook OnPlayerDisconnect(playerid)
{
    itotalRB--;
    PlayerInfoRBG[playerid][TEAM] = 0;
    PlayerInfoRBG[playerid][rbgMember] = 0;
    DeletePVar(playerid, "iMoveRabbit");
    KillTimer(GetPVarInt(playerid, "ONTIMERNPC_RBG"));
    DeletePVar(playerid, "ONTIMERNPC_RBG");
    return 1;
}
 
stock OnPlayerChangePos(itargetdeath, Float:oldpos, Float:newpos)
{
	new
        strpos[128],
        stricount[128],
        Float:iHealth;

    if(oldpos != newpos && GetPVarInt(itargetdeath, "iDeleteMoveRabbit"))
    {
        DeletePVar(itargetdeath, "iDeleteMoveRabbit");
    }
    else if(oldpos != newpos)
    {

        SetHealth(itargetdeath, 0);
        PlayerInfoRBG[itargetdeath][rbgMember] = 0;
        itotalRB--;
        Join_RBG--;
        Money_RBG += 250000;
        foreach(new i: Player)
        {
            if(RangeRGNPC(i))
            {
                format(stricount, sizeof(stricount), "{ffff00}Nguoi choi: %s' da loai", GetPlayerNameEx(itargetdeath));
                SendClientMessage(i, COLOR_YELLOW, stricount);
            }
        }
        if(GetPlayerHealth(itargetdeath, iHealth) < 10)
        {
            DeletePVar(itargetdeath, "iMoveRabbit");
        }
        format(strpos, sizeof(strpos), "{ffff00}Ban da di chuyen trong luc NPC Rabbit kiem tra: Pos: %f thanh Pos: %f!", oldpos, newpos);
        SendClientMessage(itargetdeath, COLOR_YELLOW, strpos);
    }
}

//Phạm vi hiển thị thời gian RabbitONPC hoạt động
RangeRGNPC(playerid)
{
    new Float:x, Float:y, Float:z;
    GetDynamicObjectPos(RabbitRangeOne, x, y, z);

	new Float: rangerabbit = GetPlayerDistanceFromPoint(playerid, x, y, z);
	if(rangerabbit >= 45 && rangerabbit <= 370 && PlayerInfo[playerid][pAdmin] < 1337)
	{
		return 1;
	}
    return 0;
}

CountJoin_RBG(idtarget)
{
    new Float: CheckPlayerGRBG = GetPlayerDistanceFromPoint(idtarget, 3578.0813,1443.8270,139.9089);
    if(CheckPlayerGRBG <= 50 && PlayerInfoRBG[idtarget][rbgMember] == 1)
    {
        return 1;
    }
    return 0;
}

CheckRangeRBG(playerid, Float:x, Float:y, Float:z)
{
	new Float: checkrangeRBG = GetPlayerDistanceFromPoint(playerid, x, y, z);
	if(checkrangeRBG <= 3)
	{
		return 1;
	}
    return 0;
}

forward WELCOMEJOIN_RBG(playerid);
public WELCOMEJOIN_RBG(playerid)
{
    new strtrbg[128];
    format(strtrbg, sizeof(strtrbg), "Tro Choi Con Tho\n\n%d\n\n$%s\n\nRGAME.NETWORK", Join_RBG, number_format(Money_RBG));
    SetDynamicObjectMaterialText(RBG_ShowInfoGame, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 50, 1, 0xFF00FF00, 1, 1);
    if(Join_RBG > 0) SetPVarInt(playerid, "WELCOMEJOIN_RBG", SetTimerEx("WELCOMEJOIN_RBG", 1000, false, "i", playerid));
    return 1;
}

forward ONTIMERNPC_RBG(playerid, itarget, minuterbg, secondrbg);
public ONTIMERNPC_RBG(playerid, itarget, minuterbg, secondrbg)
{
    new strtrbg[64];
    secondrbg -= 1;
    if(minuterbg == 0 && secondrbg < 30)
    {
        format(strtrbg, sizeof(strtrbg), "%d:%d", minuterbg, secondrbg);
        SetDynamicObjectMaterialText(RBG_TimerRoundOne, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 255, 1, 0xFFFF0000, 1, 1);
    }
    else
    {
        format(strtrbg, sizeof(strtrbg), "%d:%d", minuterbg, secondrbg);
        SetDynamicObjectMaterialText(RBG_TimerRoundOne, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 255, 1, 0xFF00FF00, 1, 1);
    }
    if(secondrbg > 0) SetPVarInt(playerid, "ONTIMERNPC_RBG", SetTimerEx("ONTIMERNPC_RBG", 1000, false, "iiii", playerid, itarget, minuterbg, secondrbg));
    else if(minuterbg == 0 && secondrbg == 0)
    {
        new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
        RabbitiCount = 0;
        itotalRB = 0;
        if(RangeRGNPC(itarget))
        {
            SetHealth(itarget, 0);
            PlayerInfoRBG[itarget][rbgMember] = 0;
            Join_RBG--;
            Money_RBG += 250000;
            SendClientMessageEx(itarget, -1, "Rabbit Game Ket Thuc, tieu diet tat ca nguoi choi chua hoan thanh");
        }
        else
        {
            GetDynamicObjectRot(RabbitONPC, rx, ry, rz);
            GetDynamicObjectPos(RabbitONPC, x, y, z);
            if(rz != -36.500015)
            {
                MoveDynamicObject(RabbitONPC, x, y, z, 0.2, rx, ry, rz+180);
            }
            SetPlayerPos(itarget, 3577.9014,1436.5270,139.9089); //tele người chơi còn sống phòng chờ
            SetPlayerVirtualWorld(itarget, 1);
            SetPlayerInterior(itarget, 0);
            DeletePVar(itarget, "iMoveRabbit");

            KillTimer(GetPVarInt(playerid, "NPCCHECKTIMER_RBG"));
            DeletePVar(playerid, "NPCCHECKTIMER_RBG");
            KillTimer(GetPVarInt(playerid, "OFFCHECKNPC_RBG"));
            DeletePVar(playerid, "OFFCHECKNPC_RBG");
            KillTimer(GetPVarInt(playerid, "ONCHECKNPC_RBG"));
            DeletePVar(playerid, "ONCHECKNPC_RBG");
            KillTimer(GetPVarInt(playerid, "ONTIMERNPC_RBG"));
            DeletePVar(playerid, "ONTIMERNPC_RBG");
            SendClientMessageEx(itarget, -1, "Chuc mung ban da hoan thanh vong choi 1, hay chuan bi de tiep tuc vong 2");
        }
    }
    else if(secondrbg == 0)
    {
        minuterbg--;
        secondrbg = 60;
        SetTimerEx("ONTIMERNPC_RBG", 1000, false, "iiii", playerid, itarget, minuterbg, secondrbg);
    }
    return 1;
}

forward NPCCHECKTIMER_RBG(playerid, scheckRabbit);
public NPCCHECKTIMER_RBG(playerid, scheckRabbit)
{
    RabbitiCount++;

    if(RabbitiCount < scheckRabbit) SetPVarInt(playerid, "NPCCHECKTIMER_RBG", SetTimerEx("NPCCHECKTIMER_RBG", 1000, false, "id", playerid, scheckRabbit));
    else if(RabbitiCount == scheckRabbit)
    {
        foreach(new i: Player)
        {
            DeletePVar(i, "iMoveRabbit");
        }
        RabbitiCount = 0;
        itotalRB = 0;
        SetPVarInt(playerid, "OFFCHECKNPC_RBG", SetTimerEx("OFFCHECKNPC_RBG", 1000, false, "i", playerid));
    }
    return 1;
}

forward ONCHECKNPC_RBG(playerid);
public ONCHECKNPC_RBG(playerid)
{
    new randomrb = randomEx(5,10);
    new stricount[128];
    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    GetDynamicObjectRot(RabbitONPC, rx, ry, rz);
    GetDynamicObjectPos(RabbitONPC, x, y, z);
    MoveDynamicObject(RabbitONPC, x, y, z, 0.2, rx, ry, rz-180);
    foreach(new i: Player)
    {
        if(RangeRGNPC(i))
        {
            if(GetPVarInt(i, "Injured") == 0)
            {
                SetPVarInt(i, "iDeleteMoveRabbit", 1);
                SetPVarInt(i, "iMoveRabbit", 1);
                format(stricount, sizeof(stricount), "~r~KIEM TRA");
                GameTextForPlayer(i, stricount, randomrb*1000, 6);
            }
        }
    }
    SetPVarInt(playerid, "NPCCHECKTIMER_RBG", SetTimerEx("NPCCHECKTIMER_RBG", 1000, false, "id", playerid, randomrb));
    return 1;
}

forward OFFCHECKNPC_RBG(playerid);
public OFFCHECKNPC_RBG(playerid)
{
    new randomrb = randomEx(5,8);
    new strantoan[64];
    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    GetDynamicObjectRot(RabbitONPC, rx, ry, rz);
    GetDynamicObjectPos(RabbitONPC, x, y, z);
    MoveDynamicObject(RabbitONPC, x, y, z, 0.2, rx, ry, rz+180);
    if(randomrb)
    foreach(new i: Player)
    {
        if(RangeRGNPC(i))
        {
            if(GetPVarInt(i, "Injured") != 1) itotalRB++;
            format(strantoan, sizeof(strantoan), "~g~DI CHUYEN");
            GameTextForPlayer(i, strantoan, randomrb*1000, 6);
        }
    }
    SetPVarInt(playerid, "ONCHECKNPC_RBG", SetTimerEx("ONCHECKNPC_RBG", randomrb*1000, false, "i", playerid));
    return 1;
}

forward CheckObjectGuongRBG();
public CheckObjectGuongRBG()
{
    foreach(new i: Player) {
        new Float:x, Float:y, Float:z;
        new icountcheck;
        for(new j = 0; j < sizeof(iObjectRBG); j++) {

            GetDynamicObjectPos(iObjectRBG[j][object_RBG], x, y, z);

            if(IsPlayerInRangeOfPoint(i, 3.0, x, y, z)) {
                if(iObjectRBG[j][rd_ObjectRBG]) {
                    DestroyDynamicObject(iObjectRBG[j][object_RBG]);
                    Join_RBG--;
                    Money_RBG += 250000;
                }
                else
                {
                    foreach(new k: Player) {
                        if(CheckRangeRBG(k, x, y, z))
                        {
                            icountcheck++;
                        }
                    }
                    if(icountcheck > 2) {
                        DestroyDynamicObject(iObjectRBG[j][object_RBG]);
                    }
                }
            }            
        }
    }
    return 1;
}

forward OnTimerGuongRBG(playerid, minuterbg, secondrbg);
public OnTimerGuongRBG(playerid, minuterbg, secondrbg)
{
    new strtrbg[64];
    secondrbg -= 1;
    if(minuterbg == 0 && secondrbg < 30)
    {
        format(strtrbg, sizeof(strtrbg), "%d:%d", minuterbg, secondrbg);
        SetDynamicObjectMaterialText(RBG_TimerRoundThree, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 255, 1, 0xFFFF0000, 1, 1);
    }
    else
    {
        format(strtrbg, sizeof(strtrbg), "%d:%d", minuterbg, secondrbg);
        SetDynamicObjectMaterialText(RBG_TimerRoundThree, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 255, 1, 0xFF00FF00, 1, 1);
    }

    if(secondrbg > 0) SetPVarInt(playerid, "OnTimerGuongRBG", SetTimerEx("OnTimerGuongRBG", 1000, false, "idd", playerid, minuterbg, secondrbg));
    else if(minuterbg == 0)
    {
        new ideso = 0;
        KillTimer(GetPVarInt(playerid, "OnTimerGuongRBG"));
        DeletePVar(playerid, "OnTimerGuongRBG");
        DeleteGuongRBG(playerid, ideso);
        DestroyDynamicObject(RBG_TimerRoundThree);
        SendClientMessageEx(playerid, -1, "Rabbit Game Ket Thuc, Pha huy cay cau kinh");
    }
    else if(secondrbg == 0)
    {
        minuterbg--;
        secondrbg = 60;
        SetTimerEx("OnTimerGuongRBG", 1000, false, "idd", playerid, minuterbg, secondrbg);
    }
    return 1;
}

forward DeleteGuongRBG(playerid, ideso);
public DeleteGuongRBG(playerid, ideso)
{
    new Float:x, Float:y, Float:z;
    if(GetPVarInt(playerid, "DeleteGuongRBG"))
    {
        if(iObjectRBG[ideso][idobject_RBG] == 25 || iObjectRBG[ideso][idobject_RBG] == 30 || iObjectRBG[ideso][idobject_RBG] == 35 || iObjectRBG[ideso][idobject_RBG] == 40 )
        {
            GetDynamicObjectPos(iObjectRBG[ideso][object_RBG], x, y, z);
            CreateExplosion(x, y, z, 7, 1);
        }
        DestroyDynamicObject(iObjectRBG[ideso][object_RBG]);
        ideso -= 22;
        ideso++;
        DeletePVar(playerid, "DeleteGuongRBG");
    }
    else
    {
        DestroyDynamicObject(iObjectRBG[ideso][object_RBG]);
        ideso += 22;
        SetPVarInt(playerid, "DeleteGuongRBG", 1);
    }
    if(ideso < sizeof(iObjectRBG)) SetTimerEx("DeleteGuongRBG", 100, false, "id", playerid, ideso);
    return 1;
}

forward StartTimerThree_RBG(itarget, minuterbg, secondrbg, iteamr1rbg, iteamr2rbg);
public StartTimerThree_RBG(itarget, minuterbg, secondrbg, iteamr1rbg, iteamr2rbg)
{
    new strtrbg[64];
    secondrbg -= 1;
    new Float:x, Float:y, Float:z;
    GetPlayerPos(itarget, x, y, z);
    if(secondrbg == 40 || secondrbg == 30 || secondrbg == 20 || secondrbg == 10)
    {
        if(arrTeamRBG[iteamr1rbg][POINTS] < arrTeamRBG[iteamr2rbg][POINTS])
        {
            if(PlayerInfoRBG[itarget][TEAM] == iteamr1rbg)
            {
                SetPlayerPos(itarget, x-2, y, z);
            }
            if(PlayerInfoRBG[itarget][TEAM] == iteamr2rbg)
            {
                SetPlayerPos(itarget, x-2, y, z);
            }
        }
        else 
        {
            if(PlayerInfoRBG[itarget][TEAM] == iteamr1rbg)
            {
                SetPlayerPos(itarget, x+2, y, z);
            }
            else if(PlayerInfoRBG[itarget][TEAM] == iteamr2rbg)
            {
                SetPlayerPos(itarget, x+2, y, z);
            }
        }
    }
    if(minuterbg == 0 && secondrbg < 30)
    {
        format(strtrbg, sizeof(strtrbg), "%d:%d\nTeam %d: %d\nTeam %d: %d", minuterbg, secondrbg, iteamr1rbg, arrTeamRBG[iteamr1rbg][POINTS], iteamr2rbg, arrTeamRBG[iteamr2rbg][POINTS]);
        SetDynamicObjectMaterialText(RBG_ShowInfoGameThree, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 100, 1, 0xFFFF0000, 1, 1);
    }
    else
    {
        format(strtrbg, sizeof(strtrbg), "%d:%d\nTeam %d: %d\nTeam %d: %d", minuterbg, secondrbg, iteamr1rbg, arrTeamRBG[iteamr1rbg][POINTS], iteamr2rbg, arrTeamRBG[iteamr2rbg][POINTS]);
        SetDynamicObjectMaterialText(RBG_ShowInfoGameThree, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 100, 1, 0xFF00FF00, 1, 1);
    }

    if(secondrbg > 0) SetPVarInt(itarget, "StartTimerThree_RBG", SetTimerEx("StartTimerThree_RBG", 1000, false, "idddd", itarget, minuterbg, secondrbg, iteamr1rbg, iteamr2rbg));
    else if(minuterbg == 0)
    {
        if(arrTeamRBG[iteamr1rbg][POINTS] < arrTeamRBG[iteamr2rbg][POINTS])
        {
            if(PlayerInfoRBG[itarget][TEAM] == iteamr1rbg)
            {
                PlayerInfoRBG[itarget][TEAM] = 0;
                PlayerInfoRBG[itarget][rbgMember] = 0;
                SetHealth(itarget, 0);
                Join_RBG--;
                Money_RBG += 250000;
                SendClientMessageEx(itarget, -1, "Team ban da thua va tat ca nguoi choi trong Team se loai");
            }
            if(PlayerInfoRBG[itarget][TEAM] == iteamr2rbg)
            {
                PlayerInfoRBG[itarget][TEAM] = 0;
                SetPlayerPos(itarget, 3577.9014,1436.5270,139.9089); //tele người chơi còn sống phòng chờ
                SetPlayerVirtualWorld(itarget, 1);
                SetPlayerInterior(itarget, 0);
                SendClientMessageEx(itarget, -1, "Team ban da thang va tat ca nguoi choi trong Team duoc dua ve Phong Cho");
            }
        }
        else
        {
            if(PlayerInfoRBG[itarget][TEAM] == iteamr2rbg)
            {
                PlayerInfoRBG[itarget][TEAM] = 0;
                PlayerInfoRBG[itarget][rbgMember] = 0;
                SetHealth(itarget, 0);
                Join_RBG--;
                Money_RBG += 250000;
                SendClientMessageEx(itarget, -1, "Team ban da thua va tat ca nguoi choi trong Team se loai");
            }
            if(PlayerInfoRBG[itarget][TEAM] == iteamr1rbg)
            {
                PlayerInfoRBG[itarget][TEAM] = 0;
                SetPlayerPos(itarget, 3577.9014,1436.5270,139.9089); //tele người chơi còn sống phòng chờ
                SetPlayerVirtualWorld(itarget, 1);
                SetPlayerInterior(itarget, 0);
                SendClientMessageEx(itarget, -1, "Team ban da thang va tat ca nguoi choi trong Team duoc dua ve Phong Cho");
            }
        }
        arrTeamRBG[iteamr1rbg][POINTS] = 0;
        arrTeamRBG[iteamr2rbg][POINTS] = 0;
        CancelSelectTextDraw(itarget);
        PlayerTextDrawDestroy(itarget, RabbitClickO[itarget]);
        PlayerTextDrawDestroy(itarget, RabbitTable[itarget]);
        TogglePlayerControllable(itarget, 1);
        KillTimer(GetPVarInt(itarget, "StartTimerThree_RBG"));
        DeletePVar(itarget, "StartTimerThree_RBG");
    }
    else if(secondrbg == 0)
    {
        minuterbg--;
        secondrbg = 60;
        SetTimerEx("StartTimerThree_RBG", 1000, false, "idddd", itarget, minuterbg, secondrbg, iteamr1rbg, iteamr2rbg);
    }
    return 0;
}

forward ShowTextClick(iplayerid);
public ShowTextClick(iplayerid)
{
    new Float:x = randomEx(173, 450), Float:y = randomEx(168, 320);
    RabbitClickO[iplayerid] = CreatePlayerTextDraw(iplayerid, x, y, "O");
    PlayerTextDrawFont(iplayerid, RabbitClickO[iplayerid], 1);
    PlayerTextDrawLetterSize(iplayerid, RabbitClickO[iplayerid], 0.500000, 1.000000);
    PlayerTextDrawTextSize(iplayerid, RabbitClickO[iplayerid], 10.000000, 10.000000);
    PlayerTextDrawSetOutline(iplayerid, RabbitClickO[iplayerid], 2);
    PlayerTextDrawSetShadow(iplayerid, RabbitClickO[iplayerid], 0);
    PlayerTextDrawAlignment(iplayerid, RabbitClickO[iplayerid], 2);
    PlayerTextDrawColor(iplayerid, RabbitClickO[iplayerid], -1);
    PlayerTextDrawBackgroundColor(iplayerid, RabbitClickO[iplayerid], 255);
    PlayerTextDrawBoxColor(iplayerid, RabbitClickO[iplayerid], 50);
    PlayerTextDrawUseBox(iplayerid, RabbitClickO[iplayerid], 0);
    PlayerTextDrawSetProportional(iplayerid, RabbitClickO[iplayerid], 1);
    PlayerTextDrawSetSelectable(iplayerid, RabbitClickO[iplayerid], 1);
    PlayerTextDrawShow(iplayerid, RabbitClickO[iplayerid]);
    SelectTextDraw(iplayerid,  0xFF4040AA);
    return 1;
}

//Rabbit Game Round 1
CMD:rbgone(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        if(isnull(params))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rbgone [name] - countjoin | onnpc");
            return 1;
        }
        if(strcmp(params, "countjoin", true) == 0)
        {
            Money_RBG = 0;
            Join_RBG = 0;
            foreach(new i: Player)
            {
                if(PlayerInfoRBG[i][rbgMember] == 1)
                {
                    if(CountJoin_RBG(i))
                    {
                        Join_RBG++;
                    }       
                }
            }
            if(Join_RBG == 0) return SendClientMessageEx(playerid, -1, "Hien tai chua co nguoi choi nao, /rbginvite moi co the bat dau");
            WELCOMEJOIN_RBG(playerid);
            SendClientMessageEx(playerid, -1, "Da khoi dong Rabbit Game, /rbgone onnpc, de bat dau tro choi");
            return 1;
        }
        else if(strcmp(params, "onnpc", true) == 0)
        {
            if(OnRBNPC == 0)
            {
                new minuterbg = 2, secondrbg = 60;
                OnRBNPC = 1;
                if(Join_RBG == 0) return SendClientMessageEx(playerid, -1, "Hien tai chua co nguoi choi nao, /rbginvite moi co the bat dau");
                foreach(new i: Player)
                {
                    if(PlayerInfoRBG[i][rbgMember] == 1)
                    {
                        if(CountJoin_RBG(i))
                        {
                            ONTIMERNPC_RBG(playerid, i, minuterbg, secondrbg);
                        }
                    }
                }
                OFFCHECKNPC_RBG(playerid);
                SendClientMessageToAll(-1, "ON Rabbit Game");
                return 1;
            }
            else if(OnRBNPC == 1)
            {
                OnRBNPC = 0;
                RabbitiCount = 0;
                itotalRB = 0;
                new Float:posx, Float:posy, Float:posz, Float:rx, Float:ry, Float:rz;
                GetDynamicObjectRot(RabbitONPC, rx, ry, rz);
                GetDynamicObjectPos(RabbitONPC, posx, posy, posz);
                if(rz != -36.500015)
                {
                    MoveDynamicObject(RabbitONPC, posx, posy, posz, 0.2, rx, ry, rz+180);
                }

                foreach(new i: Player)
                {
                    DeletePVar(i, "iMoveRabbit");
                }
                KillTimer(GetPVarInt(playerid, "NPCCHECKTIMER_RBG"));
                DeletePVar(playerid, "NPCCHECKTIMER_RBG");
                KillTimer(GetPVarInt(playerid, "OFFCHECKNPC_RBG"));
                DeletePVar(playerid, "OFFCHECKNPC_RBG");
                KillTimer(GetPVarInt(playerid, "ONCHECKNPC_RBG"));
                DeletePVar(playerid, "ONCHECKNPC_RBG");
                KillTimer(GetPVarInt(playerid, "ONTIMERNPC_RBG"));
                DeletePVar(playerid, "ONTIMERNPC_RBG");
                KillTimer(GetPVarInt(playerid, "WELCOMEJOIN_RBG"));
                DeletePVar(playerid, "WELCOMEJOIN_RBG");
                SendClientMessageToAll(-1, "OFF Rabbit Game");
                return 1;
            }
        }
        return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rbgone [name] - countjoin | onnpc");
    }
    else SendClientMessageEx(playerid, -1, "Ban khong du tham quyen de su dung");
    return 1;
}

//Rabbit Game Round 2
CMD:rbgthree(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        new minuterbg = 4, secondrbg = 60;
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        
        if(isnull(params))
        {
            SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /rbgthree [name] - place | starttime | delete");
            return 1;
        }
        if(strcmp(params, "place", true) == 0)
        {
            new strtrbg[128];
            RBG_TimerRoundThree = CreateDynamicObject(4735, x-4,y-125.0,z+10, 0.00000, 0.00000, -90, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), .drawdistance = 200, .streamdistance = 200);
            format(strtrbg, sizeof(strtrbg), "0:0");
            SetDynamicObjectMaterialText(RBG_TimerRoundThree, 0, strtrbg, OBJECT_MATERIAL_SIZE_512x512, "Impact", 255, 1, 0xFF00FF00, 1, 1);
            for(new i = 0; i < sizeof(iObjectRBG); i++)
            {
                if(i < 22)
                {
                    iObjectRBG[i][idobject_RBG] = i;
                    iObjectRBG[i][object_RBG] = CreateDynamicObject(1649, x, y-3, z-1, -90.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), .drawdistance = 200, .streamdistance = 200);
                    y -= 5.0;
                }
                else if(i >= 22)
                {
                    if(i == 22)
                    {
                        x -= 8.0;
                        y += 110.0;
                    }
                    iObjectRBG[i][idobject_RBG] = i;
                    iObjectRBG[i][object_RBG] = CreateDynamicObject(1649, x, y-3, z-1, -90.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), .drawdistance = 200, .streamdistance = 200);
                    y -= 5.0;
                }
            }
            for(new j = 0; j < 22; j++)
            {
                iObjectRBG[j][rd_ObjectRBG] = random(2);
                if(iObjectRBG[j][rd_ObjectRBG])
                {
                    iObjectRBG[j+22][rd_ObjectRBG] = 0;
                }
                else
                {
                    iObjectRBG[j+22][rd_ObjectRBG] = 1;
                }
            }
            return 1;
        }
        else if(strcmp(params, "starttime", true) == 0)
		{
            foreach(new i: Player)
            {
                if(CountJoin_RBG(i))
                {
                    SetPlayerPos(i, 1924.6793,1242.2229,62.8863);
                    SetPlayerVirtualWorld(i, 2);
                    SetPlayerInterior(i, 0);
                    OnTimerGuongRBG(i, minuterbg, secondrbg);
                }            
            }
            SendClientMessageEx(playerid, -1, "Da bat Thoi Giam Guong Rabbit Game");
            return 1;
        }
        else if(strcmp(params, "delete", true) == 0)
        {
            new ideso = 0;
            DestroyDynamicObject(RBG_TimerRoundThree);
            DeleteGuongRBG(playerid, ideso);

            return 1;
        }
    }
    else SendClientMessageEx(playerid, -1, "Ban khong du tham quyen de su dung lenh nay");
    return 1;
}

CMD:rabbitgame(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        SendClientMessageEx(playerid, -1, "Huong dan lenh: /rbgone - /rbgtwostart - /rbgthree - /rbginvite - /rbginviteteam - /rbgonline");
        return 1;
    }
    else SendClientMessageEx(playerid, -1, "Ban khong du tham quyen de su dung lenh nay");
    return 1;
}

CMD:rbginvite(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        new
			iTargetID,
            rbgstring[128];

        if(sscanf(params, "u", iTargetID))  {
            SendClientMessageEx(playerid, COLOR_GREY, "Su Dung: /rbginvite [player]");
        }
        else if(IsPlayerConnected(iTargetID)) {
		    if(iTargetID != playerid) {
				if(PlayerInfoRBG[iTargetID][rbgMember] == 0) {
                    format(rbgstring, sizeof(rbgstring), "Ban da moi nguoi choi: %s' tham gia Rabbit Game", GetPlayerNameEx(iTargetID));
                    SendClientMessageEx(playerid, COLOR_WHITE, rbgstring);
					SendClientMessageEx(iTargetID, COLOR_WHITE, "Ban da duoc moi tham gia Rabbit Game");
					PlayerInfoRBG[iTargetID][rbgMember] = 1;
                    return 1;
				}
				else 
                {
                    format(rbgstring, sizeof(rbgstring), "Ban da kick nguoi choi: %s' tham gia Rabbit Game", GetPlayerNameEx(iTargetID));
                    SendClientMessageEx(playerid, COLOR_WHITE, rbgstring);
					SendClientMessageEx(iTargetID, COLOR_WHITE, "Ban da bi kick ra khoi Rabbit Game, khong the tham gia Rabbit Game");
					PlayerInfoRBG[iTargetID][rbgMember] = 0;
                    return 1;
                }
			}
			else SendClientMessageEx(playerid, COLOR_GREY, "Ban khong the su dung lenh nay cho chinh minh.");
		}
		else SendClientMessageEx(playerid, COLOR_GRAD1, "Invalid player specified.");
    }
    return 1;
}

CMD:rbginviteteam(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        new
			iTargetID,
            iteamrbg,
            rbgstring[128];

        if(sscanf(params, "ud", iTargetID, iteamrbg))  {
            SendClientMessageEx(playerid, COLOR_GREY, "Su Dung: /rbginvite [player] [team]");
        }
        else if(IsPlayerConnected(iTargetID)) {
		    switch (iteamrbg)
            {
                case 1: {
                    PlayerInfoRBG[iTargetID][TEAM] = iteamrbg;
                    format(rbgstring, sizeof(rbgstring), "   %s'da tham gia Team %d.", GetPlayerNameEx(iTargetID), iteamrbg);
                }
                case 2: {
                    PlayerInfoRBG[iTargetID][TEAM] = iteamrbg;
                    format(rbgstring, sizeof(rbgstring), "   %s'da tham gia Team %d.", GetPlayerNameEx(iTargetID), iteamrbg);
                }
                case 3: {
                    PlayerInfoRBG[iTargetID][TEAM] = iteamrbg;
                    format(rbgstring, sizeof(rbgstring), "   %s'da tham gia Team %d.", GetPlayerNameEx(iTargetID), iteamrbg);
                }
                case 4: {
                    PlayerInfoRBG[iTargetID][TEAM] = iteamrbg;
                    format(rbgstring, sizeof(rbgstring), "   %s'da tham gia Team %d.", GetPlayerNameEx(iTargetID), iteamrbg);
                }
                case 5: {
                    PlayerInfoRBG[iTargetID][TEAM] = iteamrbg;
                    format(rbgstring, sizeof(rbgstring), "   %s'da tham gia Team %d.", GetPlayerNameEx(iTargetID), iteamrbg);
                }
                case 6: {
                    PlayerInfoRBG[iTargetID][TEAM] = iteamrbg;
                    format(rbgstring, sizeof(rbgstring), "   %s'da tham gia Team %d.", GetPlayerNameEx(iTargetID), iteamrbg);
                }
                default:
				{
					format(rbgstring, sizeof(rbgstring), "   Gioi hat 5 Team.");
				}
            }
            SendClientMessageEx(playerid, -1, rbgstring);
        }
        else return SendClientMessageEx(playerid, COLOR_GREY, "Invalid player specified.");
    }
    else SendClientMessageEx(playerid, -1, "Ban khong du tham quyen de su dung lenh nay");
    return 1;
}

CMD:rbgtwostart(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        new
            iteamr1rbg,
            iteamr2rbg,
            minuterbg = 0,
            secondrbg = 60,
            Float:posx1 = 3594.1404, Float:posy1 = 1882.0920, Float:posz1 = 147.6472,
            Float:posx2 = 3562.7327, Float:posy2 = 1882.0760, Float:posz2 = 147.6472;
        if(sscanf(params, "dd", iteamr1rbg, iteamr2rbg))  {
            return SendClientMessageEx(playerid, COLOR_GREY, "Su Dung: /rbgfourstart [team 1] [team 2]");
        }
        SetPlayerPos(playerid, 3578.2515,1920.5392,148.5339);
        SetPlayerVirtualWorld(playerid, 3);
        SetPlayerInterior(playerid, 0);
        foreach(new i: Player)
        {
            if(PlayerInfoRBG[i][rbgMember] == 1 && PlayerInfoRBG[i][TEAM] == iteamr1rbg)
            {
                TogglePlayerControllable(i, 0);
                SetPlayerPos(i, posx1, posy1, posz1);
                SetPlayerVirtualWorld(i, 3);
                SetPlayerInterior(i, 0);
                SetPlayerFacingAngle(i, 90);
                posx1 += 2.0;
                RabbitTable[i] = CreatePlayerTextDraw(i, 314.000000, 119.000000, "_");
                PlayerTextDrawFont(i, RabbitTable[i], 1);
                PlayerTextDrawLetterSize(i, RabbitTable[i], 100.474983, 25.000000);
                PlayerTextDrawTextSize(i, RabbitTable[i], 314.000000, 300.000000);
                PlayerTextDrawSetOutline(i, RabbitTable[i], 1);
                PlayerTextDrawSetShadow(i, RabbitTable[i], 0);
                PlayerTextDrawAlignment(i, RabbitTable[i], 2);
                PlayerTextDrawColor(i, RabbitTable[i], -1);
                PlayerTextDrawBackgroundColor(i, RabbitTable[i], 255);
                PlayerTextDrawBoxColor(i, RabbitTable[i], 135);
                PlayerTextDrawUseBox(i, RabbitTable[i], 1);
                PlayerTextDrawSetProportional(i, RabbitTable[i], 0);
                PlayerTextDrawSetSelectable(i, RabbitTable[i], 0);
                PlayerTextDrawShow(i, RabbitTable[i]);
                SetTimerEx("ShowTextClick", 5000, false, "i", i);
                SetTimerEx("StartTimerThree_RBG", 5000, false, "idddd", i, minuterbg, secondrbg, iteamr1rbg, iteamr2rbg);
            }
            else if(PlayerInfoRBG[i][rbgMember] == 1 && PlayerInfoRBG[i][TEAM] == iteamr2rbg)
            {
                TogglePlayerControllable(i, 0);
                SetPlayerPos(i, posx2, posy2, posz2);
                SetPlayerVirtualWorld(i, 3);
                SetPlayerInterior(i, 0);
                SetPlayerFacingAngle(i, -90);
                posx2 -= 2.0;
                RabbitTable[i] = CreatePlayerTextDraw(i, 314.000000, 119.000000, "_");
                PlayerTextDrawFont(i, RabbitTable[i], 1);
                PlayerTextDrawLetterSize(i, RabbitTable[i], 100.474983, 25.000000);
                PlayerTextDrawTextSize(i, RabbitTable[i], 314.000000, 300.000000);
                PlayerTextDrawSetOutline(i, RabbitTable[i], 1);
                PlayerTextDrawSetShadow(i, RabbitTable[i], 0);
                PlayerTextDrawAlignment(i, RabbitTable[i], 2);
                PlayerTextDrawColor(i, RabbitTable[i], -1);
                PlayerTextDrawBackgroundColor(i, RabbitTable[i], 255);
                PlayerTextDrawBoxColor(i, RabbitTable[i], 135);
                PlayerTextDrawUseBox(i, RabbitTable[i], 1);
                PlayerTextDrawSetProportional(i, RabbitTable[i], 0);
                PlayerTextDrawSetSelectable(i, RabbitTable[i], 0);
                PlayerTextDrawShow(i, RabbitTable[i]);
                SetTimerEx("ShowTextClick", 5000, false, "i", i);
                SetTimerEx("StartTimerThree_RBG", 5000, false, "idddd", i, minuterbg, secondrbg, iteamr1rbg, iteamr2rbg);
            }
        }
    }
    else SendClientMessageEx(playerid, -1, "Ban khong du tham quyen de su dung lenh nay");
    return 1;
}

Dialog:ShowOnline_RBG(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        SendClientMessageEx(playerid, -1, "/rbginvite [id] de xoa nguoi choi khoi Rabbit Game");
    }
    return 1;
}

CMD:rbgonline(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        new strrbg[2084];
        new icount;
        foreach(new i: Player)
        {
            if(PlayerInfoRBG[i][rbgMember] == 1)
            {
                format(strrbg, sizeof(strrbg), "%s\n(ID:%d) %s",strrbg, i, GetPlayerNameEx(i));
                icount++;
            }
        }
        Dialog_Show(playerid, ShowOnline_RBG, DIALOG_STYLE_LIST, "Online Member", strrbg, "Chon", "Huy");
    }
    else SendClientMessageEx(playerid, -1, "Ban khong du tham quyen de su dung lenh nay");
    return 1;
}