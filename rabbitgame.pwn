#include <a_samp>
#include <streamer>
#include <YSI_Coding\y_hooks>
#include <YSI_Data\y_iterate>
#pragma warning disable 239, 217, 219, 203

new
    itotalRB,
    OnRBNPC,
    RabbitiCount,
    RabbitGameTimer,
    RabbitObject;

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
    DeletePVar(playerid, "iMoveRabbit");
    KillTimer(GetPVarInt(playerid, "TimerRBG"));
    DeletePVar(playerid, "TimerRBG");
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
        itotalRB--;
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(RangeRGNPC(i))
            {
                format(stricount, sizeof(stricount), "{ffff00}Nguoi choi: %s' da loai, So nguoi choi con lai: %d", GetPlayerNameEx(itargetdeath), itotalRB);
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

RangeRGNPC(playerid)
{
    new Float:x, Float:y, Float:z;
    GetDynamicObjectPos(RabbitObject, x, y, z);

	new Float: rangerabbit = GetPlayerDistanceFromPoint(playerid, x, y, z);
	if(rangerabbit >= 10 && rangerabbit <= 700)
	{
		return 1;
	}
    return 0;
}

forward CheckPlayerMove(playerid, scheckRabbit);
public CheckPlayerMove(playerid, scheckRabbit)
{
    RabbitiCount++;

    if(RabbitiCount < scheckRabbit) SetTimerEx("CheckPlayerMove", 1000, false, "id", playerid, scheckRabbit);
    else if(RabbitiCount == scheckRabbit)
    {
        foreach(new i: Player)
        {
            DeletePVar(i, "iMoveRabbit");
        }
        RabbitiCount = 0;
        itotalRB = 0;
        new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
        GetDynamicObjectRot(RabbitObject, rx, ry, rz);
        GetDynamicObjectPos(RabbitObject, x, y, z);
        MoveDynamicObject(RabbitObject, x, y, z, 0.2, 0.0, 0.0, rz+180);
        SetPVarInt(playerid, "OnReadyRBG", SetTimerEx("ReadyRabbitGame", 1000, false, "i", playerid));
    }
    return 1;
}

forward OnNPCRabbitGame(playerid);
public OnNPCRabbitGame(playerid)
{
    new randomrb = randomEx(4,8);
    new stricount[128];
    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;
    GetDynamicObjectRot(RabbitObject, rx, ry, rz);
    GetDynamicObjectPos(RabbitObject, x, y, z);
    MoveDynamicObject(RabbitObject, x, y, z, 0.2, rx, ry, rz-180);
    foreach(new i: Player)
    {
        if(RangeRGNPC(i))
        {
            if(GetPVarInt(playerid, "Injured") == 0)
            {
                SetPVarInt(i, "iplayerjoin", i);
                SetPVarInt(i, "iDeleteMoveRabbit", 1);
                SetPVarInt(i, "iMoveRabbit", 1);
                format(stricount, sizeof(stricount), "~r~KIEM TRA");
                GameTextForPlayer(i, stricount, randomrb*1000, 6);
            }
        }
    }
    SetPVarInt(playerid, "OnCheckMoveRGB", SetTimerEx("CheckPlayerMove", 1000, false, "id", playerid, randomrb));
    return 1;
}

forward ShowTextTimeRBG(playerid, minuterbg, secondrbg);
public ShowTextTimeRBG(playerid, minuterbg, secondrbg)
{
    new strtrbg[64];
    secondrbg -= 5;
    format(strtrbg, sizeof(strtrbg), "Thoi Gian Con Lai: %d:%d", minuterbg, secondrbg);
    SendClientMessageEx(playerid, -1, strtrbg);
    if(secondrbg > 0) SetPVarInt(playerid, "TimerRBG", SetTimerEx("ShowTextTimeRBG", 5000, false, "idd", playerid, minuterbg, secondrbg));
    else if(minuterbg == 0)
    {
        OnRBNPC = 0;
        RabbitiCount = 0;
        itotalRB = 0;
        foreach(new i: Player)
        {
            if(RangeRGNPC(playerid))
            {
                SetHealth(playerid, 0);
            }
        }
        DeletePVar(playerid, "iMoveRabbit");
        KillTimer(GetPVarInt(playerid, "OnCheckMoveRGB"));
        DeletePVar(playerid, "OnCheckMoveRGB");
        KillTimer(GetPVarInt(playerid, "OnReadyRBG"));
        DeletePVar(playerid, "OnReadyRBG");
        DeletePVar(playerid, "ReadyOnNPCRBG");
        KillTimer(GetPVarInt(playerid, "TimerRBG"));
        DeletePVar(playerid, "TimerRBG");
        DestroyDynamicObject(RabbitObject);
        SendClientMessageEx(playerid, -1, "Rabbit Game Ket Thuc, tieu diet tat ca nguoi choi chua hoan thanh");
    }
    else if(secondrbg == 0)
    {
        minuterbg--;
        secondrbg = 60;
        SetTimerEx("ShowTextTimeRBG", 5000, false, "idd", playerid, minuterbg, secondrbg);
    }
    return 1;
}
forward ReadyRabbitGame(playerid);
public ReadyRabbitGame(playerid)
{
    new randomrb = randomEx(4,8);
    new strantoan[64];

    foreach(new i: Player)
    {
        if(RangeRGNPC(i))
        {
            itotalRB++;
        }
    }
    foreach(new i: Player)
    {
        if(RangeRGNPC(i))
        {
            format(strantoan, sizeof(strantoan), "~g~AN TOAN: DI CHUYEN");
            GameTextForPlayer(i, strantoan, randomrb*1000, 6);
        }
    }
    SetPVarInt(playerid, "ReadyOnNPCRBG", SetTimerEx("OnNPCRabbitGame", randomrb*1000, false, "i", playerid));
    return 1;
}

CMD:rgnpc(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        if(OnRBNPC == 0)
        {
            new minuterbg = 2, secondrbg = 60;
            new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:a;
            itotalRB = 0;
            OnRBNPC = 1;
            
            GetPlayerPos(playerid, x, y, z);
            GetPlayerFacingAngle(playerid, a);
            RabbitObject = CreateDynamicObject(14467, x, y, z+1.0, 0.00000, 0.00000, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), .drawdistance = 600, .streamdistance = 600);
            foreach(new i: Player)
            {
                if(RangeRGNPC(i))
                {
                    ShowTextTimeRBG(i, minuterbg, secondrbg);
                }
            }
            SetTimerEx("ReadyRabbitGame", 1000, false, "i", playerid);
            SendClientMessageToAll(-1, "ON Rabbit Game");
            return 1;
        }
        else if(OnRBNPC == 1)
        {
            OnRBNPC = 0;
            RabbitiCount = 0;
            itotalRB = 0;
            
            KillTimer(GetPVarInt(playerid, "OnCheckMoveRGB"));
            DeletePVar(playerid, "OnCheckMoveRGB");
            KillTimer(GetPVarInt(playerid, "OnReadyRBG"));
            DeletePVar(playerid, "OnReadyRBG");
            KillTimer(GetPVarInt(playerid, "ReadyOnNPCRBG"));
            DeletePVar(playerid, "ReadyOnNPCRBG");
            foreach(new i: Player)
            {
                DeletePVar(i, "iMoveRabbit");
                KillTimer(GetPVarInt(i, "TimerRBG"));
                DeletePVar(i, "TimerRBG");

            }
            DestroyDynamicObject(RabbitObject);
            SendClientMessageToAll(-1, "OFF Rabbit Game");
            return 1;
        }
    }
    else return SendClientMessageEx(playerid, -1, "Ban khong du tham quyen de su dung");
    return 1;
}