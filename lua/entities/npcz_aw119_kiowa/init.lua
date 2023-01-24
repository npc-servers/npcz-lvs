--SHITTY CODE BY MERYDIAN
--lmao^
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( "shared.lua" )

ENT.PassengerSeats = {
    {
        pos = Vector( 49.173, -18.594, -80.958 ),
        ang = Angle( 0, -90, 0 )
    },
    {
        pos = Vector( -2.865, -18.586, -80.958 ),
        ang = Angle( 0, -90, 0 )
    },
    {
        pos = Vector( -2.865, 2.257, -80.958 ),
        ang = Angle( 0, -90, 0 )
    }
}

function ENT:OnSpawn()
    local driverSeat = self:AddDriverSeat( Vector( 49.173, 18.594, -80.958 ), Angle( 0, -90, 0 ) )
    driverSeat:SetCameraDistance( 0.2 )

    for _, seat in ipairs( self.PassengerSeats ) do
        self:AddPassengerSeat( seat.pos, seat.ang )
    end

    self:AddEngineSound( Vector( 40, 0, 0 ) )

    self.Rotor = self:AddRotor( Vector( 0, 0, 40 ), Angle(), 250, 4000 )
    self.Rotor:SetHP( 50 )
    function self.Rotor:OnDestroyed( rotor )
        local id = rotor:LookupBone( "main_rotor" )
        rotor:ManipulateBoneScale( id, Vector( 0, 0, 0 ) )
        rotor:DestroyEngine()
        rotor:EmitSound( "physics/metal/metal_box_break2.wav" )
    end

    self.TailRotor = self:AddRotor( Vector( -300, 15, -25 ), Angle( 0, 0, 90 ), 55, 4000 )
    self.TailRotor:SetHP( 30 )
    function self.TailRotor:OnDestroyed( rotor )
        local id = rotor:LookupBone( "backside_rotor" )
        rotor:ManipulateBoneScale( id, Vector( 0, 0, 0 ) )
        rotor:EmitSound( "physics/metal/metal_box_break2.wav" )
        rotor:DestroySteering( -2.5 )
    end
end

-- function ENT:HandleWeapons( Fire1, Fire2 )
--     local Driver = self:GetDriver()

--     if IsValid( Driver ) then
--         if self:GetAmmoPrimary() > 0 then
--             Fire1 = Driver:KeyDown( IN_ATTACK )
--         end

--         if self:GetAmmoSecondary() > 0 then
--             Fire2 = Driver:KeyDown( IN_ATTACK2 )
--         end
--     end

--     if Fire1 then
--         self:PrimaryAttack()
--         self:ResetSequence( "minigunspin" )
--     else
--         self:ResetSequence( "idle" )
--     end

--     if self.OldFire2 ~= Fire2 then
--         if Fire2 then
--             self:SecondaryAttack()
--         end

--         self.OldFire2 = Fire2
--     end

--     if self.OldFire ~= Fire1 then
--         if Fire1 then
--             self.wpn1 = CreateSound( self, "reiktek_industries_kiowa/aw119_kiowa/kiowa_gun.wav" )
--             self.wpn1:Play()

--             self:CallOnRemove( "stopmesounds1", function( ent )
--                 if ent.wpn1 then
--                     ent.wpn1:Stop()
--                 end
--             end )
--         else
--             if self.OldFire == true then
--                 if self.wpn1 then
--                     self.wpn1:Stop()
--                 end

--                 self.wpn1 = nil
--                 self:EmitSound( "reiktek_industries_kiowa/aw119_kiowa/kiowa_gun_stop_final.wav" )
--             end
--         end

--         self.OldFire = Fire1
--     end
-- end

-- function ENT:OnEngineStartInitialized()
--     self:EmitSound( "reiktek_industries_kiowa/aw119_kiowa/chopper_start.wav" )
-- end
