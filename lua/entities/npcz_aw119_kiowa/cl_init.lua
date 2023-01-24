-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
-- DO NOT EDIT OR REUPLOAD THIS FILE
--i am editing this file
include( "shared.lua" )

-- function ENT:CalcEngineSound( RPM, _, Doppler )
--     if not self.ENG then return end
--     local THR = RPM / self:GetLimitRPM()

--     self.ENG:ChangePitch( math.Clamp( math.min( RPM / self:GetIdleRPM(), 1 ) * 75 + Doppler + THR * 20, 0, 255 ) )
--     self.ENG:ChangeVolume( math.Clamp( THR, 0.8, 1 ) )
-- end

-- function ENT:OnRemove()
--     self:SoundStop()

--     -- if we have an rotor
--     if IsValid( self.TheRotor ) then
--         self.TheRotor:Remove() -- remove it
--     end
-- end

-- function ENT:EngineActiveChanged( bActive )
--     if bActive then
--         self.ENG = CreateSound( self, "reiktek_industries_kiowa/aw119_kiowa/chopperblade_fly.wav" )
--         self.ENG:PlayEx( 0, 0 )
--     else
--         self:SoundStop()
--     end
-- end

-- function ENT:SoundStop()
--     if not self.ENG then return end
--     self.ENG:Stop()
-- end

-- function ENT:AnimCabin()
--     local FT = FrameTime() * 10
--     local Pitch = self:GetRotPitch()
--     local Yaw = self:GetRotYaw()
--     local Roll = -self:GetRotRoll()

--     self.joystickPitch = self.joystickPitch and self.joystickPitch + ( Pitch - self.joystickPitch ) * FT or 0
--     self.joystickYaw = self.joystickYaw and self.joystickYaw + ( Yaw - self.joystickYaw ) * FT or 0
--     self.joystickRoll = self.joystickRoll and self.joystickRoll + ( Roll - self.joystickRoll ) * FT or 0

--     local joystickbone1 = self:LookupBone( "Joystick_1" )
--     if not joystickbone1 then return end

--     local joystickbone2 = self:LookupBone( "Joystick_2" )
--     if not joystickbone2 then return end

--     self:ManipulateBoneAngles( joystickbone1, Angle( 0, self.joystickPitch * 15, self.joystickYaw * 15, self.joystickRoll * 15 ) )
--     self:ManipulateBoneAngles( joystickbone2, Angle( 0, self.joystickPitch * 15, self.joystickYaw * 15, self.joystickRoll * 15 ) )
-- end

-- function ENT:DamageFX()
--     self.nextDFX = self.nextDFX or 0

--     if self.nextDFX < CurTime() then
--         self.nextDFX = CurTime() + 0.05

--         local HP = self:GetHP()
--         local MaxHP = self:GetMaxHP()

--         if HP > MaxHP * 0.25 then return end

--         local effectdata = EffectData()
--             effectdata:SetOrigin( self:LocalToWorld( Vector( -10, 25, -10 ) ) )
--             effectdata:SetNormal( self:GetUp() )
--             effectdata:SetMagnitude( math.Rand( 0.5, 1.5 ) )
--             effectdata:SetEntity( self )
--         util.Effect( "lvs_exhaust_fire", effectdata )
--     end
-- end

function ENT:AnimateRotor()
    local Rot = Angle( self.RPM, 0, 0 )

    local MainR = self:LookupBone( "main_rotor" )
    if not MainR then return end

    local BackR = self:LookupBone( "backside_rotor" )
    if not BackR then return end

    local RPM = self:GetThrottle() * 2500
    local PhysRot = RPM < 700

    self.RPM = self.RPM and self.RPM + RPM * FrameTime() * ( PhysRot and 4 or 1.1 ) or 0
    self:SetBodygroup( 1, PhysRot and 0 or 1 )
    self:ManipulateBoneAngles( MainR, Rot )
    self:ManipulateBoneAngles( BackR, Rot )
    self:SetPoseParameter( "rotor_spin", self.RPM )
    self:InvalidateBoneCache()
end

function ENT:OnFrame()
    self:AnimateRotor()
    --self:DamageFX()
end
