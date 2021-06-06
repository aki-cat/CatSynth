local Class = require "util.class"

local Envelope = Class "Envelope"

-- params (table)
-- params.maxVolume (seconds) default = 1.25
-- params.minVolume (seconds) default = 0
-- params.attack (seconds)
-- params.decay (seconds)
-- params.sustain (seconds)
-- params.release (seconds)
function Envelope:__init(params)
    params = params or {}
    self._maxVolume = params.maxVolume or 1.25
    self._minVolume = params.minVolume or 0
    self._attack = params.attack or 0.01
    self._decay = params.decay or 0.1
    self._sustainVolume = params.sustain or 0.5
    self._release = params.release or 2.5
    self._stopTime = -1
    self._intensity = params.intensity or 1
end

function Envelope:calculate(tn)
    local out = 0

    local attackEnd = self._attack
    local decayEnd = attackEnd + self._decay
    local sustainEnd = self._stopTime
    local releaseEnd = sustainEnd + self._release
    local minVolume = self._intensity * self._minVolume
    local maxVolume = self._intensity * self._maxVolume
    local sustainVolume = self._intensity * self._sustainVolume

    if tn < attackEnd then
        local yOrigin = minVolume
        local yVector = maxVolume - yOrigin
        local tOrigin = 0
        local tNormalized = (tn - tOrigin) / self._attack
        out = yOrigin + yVector * tNormalized
    elseif tn < decayEnd then
        local yOrigin = maxVolume
        local yVector = sustainVolume - yOrigin
        local tOrigin = attackEnd
        local tNormalized = (tn - tOrigin) / self._decay
        out = yOrigin + yVector * tNormalized
    elseif not self:hasStopTime() or tn < sustainEnd then
        out = sustainVolume
    elseif tn < releaseEnd then
        local yOrigin = sustainVolume
        local yVector = 0 - sustainVolume
        local tOrigin = sustainEnd
        local tNormalized = (tn - tOrigin) / sustainVolume
        out = yOrigin + yVector * tNormalized
    else
        out = 0
    end

    return math.max(out, 0)
end

function Envelope:isDead(tn)
    return self:hasStopTime() and tn > self._stopTime + self._release
end

function Envelope:setStopTime(t)
    self._stopTime = math.max(t, self._attack + self._decay)
end

function Envelope:hasStopTime()
    return self._stopTime > 0
end

function Envelope:getAttackVolume()
    return self._maxVolume
end

function Envelope:getReleaseVolume()
    return self._minVolume
end

function Envelope:getADSR()
    return {
        attack = self:getAttack(),
        decay = self:getDecay(),
        sustain = self:getSustain(),
        release = self:getRelease()
    }
end

function Envelope:getAttack()
    return self._attack
end

function Envelope:getDecay()
    return self._decay
end

function Envelope:getSustain()
    return self._sustainVolume
end

function Envelope:getRelease()
    return self._release
end

function Envelope:setAttackVolume(f)
    self._maxVolume = f
end

function Envelope:setReleaseVolume(f)
    self._minVolume = f
end

function Envelope:setAttack(f)
    self._attack = f
end

function Envelope:setDecay(f)
    self._decay = f
end

function Envelope:setSustain(f)
    self._sustainVolume = f
end

function Envelope:setRelease(f)
    self._release = f
end

function Envelope:setADSR(a, s, d, r)
    self._attack = a
    self._decay = d
    self._sustainVolume = s
    self._release = r
end

return Envelope
