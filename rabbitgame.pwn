#include <a_samp>
#include <YSI_Coding\y_hooks>
#pragma warning disable 239, 217, 219, 203

new
    OnRBNPC,
    RabbitiCount,
    RabbitGameTimer,
    RabbitGameNPC;

hook OnGameModeInit(){
        
        RabbitGameNPC = CreateActor(27, 1725.3400,1453.2429,10.8200,269.4360);
        SetActorVirtualWorld(RabbitGameNPC, 0);
        SetActorInvulnerable(RabbitGameNPC, true);
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
 
stock OnPlayerChangePos(itargetdeath, Float:oldpos, Float:newpos)
{
	new
        strpos[128],
        uphealth,
        Float:iHealth;
    if(oldpos == newpos)
    {

    }
    else if(oldpos != newpos && GetPVarInt(itargetdeath, "iDeleteMoveRabbit"))
    {
        DeletePVar(itargetdeath, "iDeleteMoveRabbit");
    }
    else if(oldpos != newpos)
    {

        SetHealth(itargetdeath, 0);
        if(GetPlayerHealth(itargetdeath, iHealth) < 10)
        {
            DeletePVar(itargetdeath, "iMoveRabbit");
        }
        format(strpos, sizeof(strpos), "Ban da thay doi di chuyen trong luc NPC Rabbit kiem tra: Pos: %f thanh Pos: %f!", oldpos, newpos);
        SendClientMessage(itargetdeath, 0xFFFFFFFF, strpos);
    }
}

forward CheckPlayerMove(itargetplayer);
public CheckPlayerMove(itargetplayer)
{
    RabbitiCount++;
    if(RabbitiCount < 10) SetPVarInt(itargetplayer, "DeleteOnRabbit", SetTimerEx("CheckPlayerMove", 1000, false, "i", itargetplayer));
    else if(RabbitiCount == 10)
    {
        SendClientMessage(itargetplayer, -1, "Chay Ngay Di");    
        DeletePVar(itargetplayer, "iMoveRabbit");
        KillTimer(GetPVarInt(itargetplayer, "DeleteOnRabbit"));
        RabbitiCount = 0;
    }
}

RangeRGNPC(playerid)
{
	new Float:x, Float:y, Float:z;
    GetActorPos(RabbitGameNPC, x, y, z);

	new Float: rangerabbit = GetPlayerDistanceFromPoint(playerid, x, y, z);
	if(rangerabbit >= 10 && rangerabbit <= 100)
	{
		return 1;
	}
    return 0;
}

forward OnNPCRabbitGame(playerid);
public OnNPCRabbitGame(playerid)
{
    SendClientMessageToAll(-1, "DUNG CHAY NUA");
    ApplyActorAnimation(RabbitGameNPC, "PED", "endchat_03", 4.1, 1, 0, 0, 0, 1);
    foreach(new i: Player)
    {
        if(RangeRGNPC(i))
        {
            SetPVarInt(i, "iplayerjoin", i);
            SetPVarInt(i, "iDeleteMoveRabbit", 1);
            SetPVarInt(i, "iMoveRabbit", 1);
            CheckPlayerMove(i);
        }
    }
}

CMD:rgnpc(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] >= 1338)
    {
        if(OnRBNPC == 0)
        {
            OnRBNPC = 1;
            ApplyActorAnimation(RabbitGameNPC, "BD_FIRE", "BD_GF_Wave", 4.1, 0, 1, 1, 1, 0);

            SetTimerEx("OnNPCRabbitGame", 5000, false, "i", playerid);
            SendClientMessageToAll(-1, "ON Rabbit Game");
            return 1;
        }
        else if(OnRBNPC == 1)
        {
            OnRBNPC = 0;
            RabbitiCount = 0;
            ClearActorAnimations(RabbitGameNPC);
            foreach(new i: Player)
            {
                if(RangeRGNPC(i))
                {
                    DeletePVar(i, "iMoveRabbit");
                    KillTimer(GetPVarInt(i, "DeleteOnRabbit"));
                }
            }
            SendClientMessageToAll(-1, "OFF Rabbit Game");
            return 1;
        }
    }
    return 1;
}