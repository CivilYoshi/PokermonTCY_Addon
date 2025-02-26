local beastball = {
  name = "beastball",
  key = "beastball",
  set = "Spectral",
  loc_vars = function(self, info_queue, center)
   info_queue[#info_queue+1] = {set = 'Other', key = 'ultrabeast'}
  end,
  pos = { x = 5, y = 5 },
  soul_pos = { x = 6, y = 5 },
  atlas = "mart_tcy",
  cost = 4,
  pokeball = true,
  hidden = true,
  soul_set = "Planet",
  soul_rate = .007,
  unlocked = true,
  discovered = true,
  can_use = function(self, card)
    if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
        return true
    else
        return false
    end
  end,
  use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        local _card = create_random_poke_joker("beastball", "Ultra Beast")
        _card:add_to_deck()
        G.jokers:emplace(_card)
        return true end }))
    delay(0.6)
  end
}

return {name = "Items",
      list = {beastball}
}