DEFINE_BASECLASS( "lvs_base_helicopter" )

ENT.Type = "anim"
ENT.PrintName = "AW-119 Kiowa"
ENT.Author = "NPCZ"
ENT.Category = "[LVS] NPCZ Aircraft"
ENT.Spawnable = true
ENT.MDL = "models/models/helis/aw119_kiowa/aw119_kiowa.mdl"

ENT.MaxVelocity = 2150

ENT.ThrustUp = 1
ENT.ThrustDown = 0.8
ENT.ThrustRate = 1

ENT.ThrottleRateUp = 0.2
ENT.ThrottleRateDown = 0.2

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 1

ENT.ForceLinearDampingMultiplier = 1.5
ENT.ForceAngleMultiplier = 1

ENT.EngineSounds = {
    {
        sound = "^lvs/vehicles/helicopter/loop_near.wav",
        sound_int = "lvs/vehicles/helicopter/loop_interior.wav",
        Pitch = 0,
        PitchMin = 0,
        PitchMax = 255,
        PitchMul = 100,
        Volume = 1,
        VolumeMin = 0,
        VolumeMax = 1,
        SoundLevel = 125,
        UseDoppler = true,
    },
    {
        sound = "^lvs/vehicles/helicopter/loop_dist.wav",
        sound_int = "",
        Pitch = 0,
        PitchMin = 0,
        PitchMax = 255,
        PitchMul = 100,
        Volume = 1,
        VolumeMin = 0,
        VolumeMax = 1,
        SoundLevel = 125,
        UseDoppler = true,
    },
}

-- CONFIG
-- https://github.com/Blu-x92/lvs_helicopters/blob/03dff59e23/lua/entities/lvs_base_helicopter/shared.lua#L1-L28

-- https://github.com/Blu-x92/lvs_base/blob/73a3df0e0df2de433fce2ebc533157e5ed545026/lua/entities/lvs_base/sh_weapons.lua#L22
ENT.gunTable = {
    Ammo = 3000,
    Delay = 0,
    Icon = Material( "lvs/weapons/mg.png" )
}

function ENT.gunTable.StartAttack( ent )
    ent.GunSound = ent:StartLoopingSound( "reiktek_industries_kiowa/aw119_kiowa/kiowa_gun.wav" )
    ent:ResetSequence( "minigunspin" )
end

function ENT.gunTable.FinishAttack( ent )
    ent:StopLoopingSound( ent.GunSound )
    ent:ResetSequence( "idle" )
    ent:EmitSound( "reiktek_industries_kiowa/aw119_kiowa/brr_stop.wav" )
end

function ENT.gunTable.Attack( ent )
    -- https://github.com/Blu-x92/lvs_base/blob/73a3df0e0df2de433fce2ebc533157e5ed545026/lua/lvs_framework/autorun/lvs_bulletsystem.lua#L183
    local gunPos = ent:LocalToWorld( Vector( 20.02, 47.291, -82 ) )
    local bulletTable = {
        Velocity = 20000,
        Dir = ent:GetForward(),
        Src = gunPos,
        Spread = Vector( 0.025, 0.025, 0.025 ),
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


ENT.rocketTable = {
    Ammo = 30,
    Delay = 1,
    Icon = Material( "lvs/weapons/missile.png" )
}

function ENT.rocketTable.Attack( ent )
    local driver = ent:GetDriver()
    local rocket = ents.Create( "lvs_missile" )
    rocket:SetPos( ent:LocalToWorld( Vector( -9.683, -56.04, -85.209 ) ) )
    rocket:SetAngles( ent:GetAngles() )
    rocket:SetParent( ent )
    rocket:Spawn()
    rocket:Activate()
    rocket:SetAttacker( IsValid( driver ) and driver or ent )
    rocket:SetEntityFilter( ent:GetCrosshairFilterEnts() )
    rocket:SetSpeed( ent:GetVelocity():Length() + 5000 )
    rocket:SetDamage( 400 )
    rocket:SetRadius( 150 )
    rocket:Enable()
    rocket:EmitSound( "npc/waste_scanner/grenade_fire.wav" )

    ent:TakeAmmo()
end

function ENT:InitWeapons()
    self:AddWeapon( self.gunTable )
    self:AddWeapon( self.rocketTable )
end
