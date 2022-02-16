function CreateRagdoll(ply)
   if not IsValid(ply) then return end

   local rag = ents.Create("prop_ragdoll")
   if not IsValid(rag) then return nil end

   rag:SetPos(ply:GetPos())
   rag:SetModel(ply:GetModel())
   rag:SetSkin(ply:GetSkin())
   for key, value in pairs(ply:GetBodyGroups()) do
      rag:SetBodygroup(value.id, ply:GetBodygroup(value.id))
   end
   rag:SetAngles(ply:GetAngles())
   rag:SetColor(ply:GetColor())

   rag:Spawn()
   rag:Activate()

   -- nonsolid to players, but can be picked up and shot
   local rag_collide = true
   rag:SetCollisionGroup(rag_collide and COLLISION_GROUP_WEAPON or COLLISION_GROUP_DEBRIS_TRIGGER)

   -- position the bones
   local num = rag:GetPhysicsObjectCount()-1
   local v = ply:GetVelocity()

   for i=0, num do
      local bone = rag:GetPhysicsObjectNum(i)
      if IsValid(bone) then
         local bp, ba = ply:GetBonePosition(rag:TranslatePhysBoneToBone(i))
         if bp and ba then
            bone:SetPos(bp)
            bone:SetAngles(ba)
         end

         -- not sure if this will work:
         bone:SetVelocity(v)
      end
   end

   return rag -- we'll be speccing this
end

hook.Add("DoPlayerDeath", "~PlayerRagdoll-DoPlayerDeath", function(ply)
	local rag = CreateRagdoll(ply)
	if IsValid(ply.ragdoll) then
		ply.ragdoll:Remove()
	end
	ply.ragdoll = rag
	return 1
end)

hook.Add("PlayerSpawn", "PlayerRagdoll-PlayerSpawn", function(ply)
	if IsValid(ply.ragdoll) then
		ply.ragdoll:Remove()
	end
end)