-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadModel(Hash)
	local Hash = GetHashKey(Hash)

	while not HasModelLoaded(Hash) do
		RequestModel(Hash)
		Wait(1)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadAnim(Dict)
	while not HasAnimDictLoaded(Dict) do
		RequestAnimDict(Dict)
		Wait(1)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADTEXTURE
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadTexture(Library)
	while not HasStreamedTextureDictLoaded(Library) do
		RequestStreamedTextureDict(Library,false)
		Wait(1)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMOVEMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadMovement(Library)
	while not HasAnimSetLoaded(Library) do
		RequestAnimSet(Library)
		Wait(1)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADPTFXASSET
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadPtfxAsset(Library)
	while not HasNamedPtfxAssetLoaded(Library) do
		RequestNamedPtfxAsset(Library)
		Wait(1)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADNETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadNetwork(Network)
	local Network = NetworkGetEntityFromNetworkId(Network)
	while not DoesEntityExist(Network) do
		Network = NetworkGetEntityFromNetworkId(Network)
		Wait(1)
	end

	local Control = NetworkRequestControlOfEntity(Network)
	while not Control do
		Control = NetworkRequestControlOfEntity(Network)
		Wait(1)
	end

	return Network
end