DEFINE_BASECLASS( "lvs_base_helicopter" )

ENT.Type = "anim"
ENT.PrintName = "AW-119 Kiowa"
ENT.Author = "NPCZ"
ENT.Category = "[LVS] NPCZ Aircraft"
ENT.Spawnable = true
ENT.MDL = "models/models/helis/aw119_kiowa/aw119_kiowa.mdl"
-- ENT.AITEAM = 2
-- ENT.Inertia = Vector( 5000, 5000, 5000 )
-- ENT.Drag = 0
-- ENT.SeatPos = Vector( 49.173, 18.594, -80.958 )
-- ENT.SeatAng = Angle( 0, -90, 0 )
-- ENT.IdleRPM = 500
-- ENT.MaxRPM = 3000
-- ENT.LimitRPM = 3000
-- ENT.MaxThrustHeli = 10.2
-- ENT.MaxTurnPitchHeli = 30
-- ENT.MaxTurnYawHeli = 80
-- ENT.MaxTurnRollHeli = 120
-- ENT.ThrustEfficiencyHeli = 4
-- ENT.RotorPos = Vector( 0, 0, 27.826 )
-- ENT.RotorAngle = Angle( 0, 0, 0 )
-- ENT.RotorRadius = 280
-- ENT.MaxHealth = 2000
-- ENT.MaxPrimaryAmmo = 3000
-- ENT.MaxSecondaryAmmo = 14

-- https://github.com/Blu-x92/lvs_base/blob/73a3df0e0df2de433fce2ebc533157e5ed545026/lua/entities/lvs_base/sh_weapons.lua#L22
local gunTable = LVS:GetWeaponPreset( "LMG" )
gunTable.Ammo = 3000
gunTable.Delay = 0
gunTable.Damage = 10

local gunPosLocal = Vector( 20.02, 47.291, -84.527 )

function gunTable.StartAttack( ent )
    ent.GunSound = ent:StartLoopingSound( "reiktek_industries_kiowa/aw119_kiowa/kiowa_gun.wav" )
    ent:ResetSequence( "minigunspin" )
end

function gunTable.FinishAttack( ent )
    ent:StopLoopingSound( ent.GunSound )
    ent:ResetSequence( "idle" )
    ent:EmitSound( "reiktek_industries_kiowa/aw119_kiowa/brr_stop.wav" )
end

function gunTable.Attack( ent )
    -- https://github.com/Blu-x92/lvs_base/blob/73a3df0e0df2de433fce2ebc533157e5ed545026/lua/lvs_framework/autorun/lvs_bulletsystem.lua#L183
    local gunPos = ent:LocalToWorld( gunPosLocal )
    local bulletTable = {
        Velocity = 1000,
        Dir = ent:GetForward(),
        Src = gunPos,
        Spread = Vector( 0.05, 0.05, 0.05 ),
        Entity = ent,
        TracerName = "lvs_tracer_yellow",
        HullSize = 3
    }

    local effectdata = EffectData()
    effectdata:SetOrigin( gunPos )
    effectdata:SetNormal( ent:GetForward() )
    effectdata:SetEntity( ent )
    util.Effect( "lvs_muzzle", effectdata )

    ent:LVSFireBullet( bulletTable )
    ent:TakeAmmo()
end

function ENT:InitWeapons()
    self:AddWeapon( gunTable )
end
