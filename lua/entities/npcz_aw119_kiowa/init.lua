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

    function self.Rotor:CheckRotorClearance()
        if self:GetDisabled() then self:DeleteRotorWash() return end

        local base = self:GetBase()

        if not IsValid( base ) then self:DeleteRotorWash() return end

        if not base:GetEngineActive() then self:DeleteRotorWash() return end
        if base:GetThrottle() > 0.5 then
            self:CreateRotorWash()
        else
            self:DeleteRotorWash()
        end
    end

    self.TailRotor = self:AddRotor( Vector( -300, 15, -25 ), Angle( 0, 0, 90 ), 55, 4000 )
    self.TailRotor:SetHP( 30 )
    function self.TailRotor:OnDestroyed( rotor )
        local id = rotor:LookupBone( "backside_rotor" )
        rotor:ManipulateBoneScale( id, Vector( 0, 0, 0 ) )
        rotor:EmitSound( "physics/metal/metal_box_break2.wav" )
        rotor:DestroySteering( -2.5 )
    end

    self.Engine = self:AddEngineSound( Vector( 0, 0, -20 ) )

    self:SetSkin( math.random( 0, 15 ) ) -- random skin
end

function ENT:OnEngineActiveChanged( active )
    if not active then return end
    self.Engine:EmitSound( "lvs/vehicles/helicopter/start.wav" )
end
