-- Welcome to en-us.lua!
-- friendly reminder that in the us we say things like "color" and not "colour"
-- This is also the default file, if there are things here that are "missing" from other files it will use this one instead

--Progress report: (this is the english file so it doesn't really matter but this is for consistency)

--[[
Decks: Yes
Jokers: Yes
Settings/Mod: Yes
Items: Yes
Energy: Yes
Deck Sleeves (requires Decksleeves Mod): Yes
Boss Blinds: Yes
Challenges: Yes
Spectrals: Yes
Tarots: Yes (there aren't any lmao)
Stickers: Yes
Planets: Yes (there aren't any lmao)
Dictonary: Yes
Editions: Yes
Vouchers: Yes
Tags: Yes
Misc Infoqueues (ancient, baby, eitem, Type, etc): Yes
Other (packs, stickers, etc): Yes
Misc: Yes
]]--


return {
    descriptions = {
       
        Joker = {
			j_tcy_lugia = {
					name = 'Lugia',
					text = {
						"When blind is selected, remove one",
						"energy from leftmost {X:fire,C:white}Fire{}, {X:lightning}Lightning{},",
						"and {X:water,C:white}Water{} Joker",
						"{br:4}text needs to be here to work",
						"Gains {X:red,C:white}X4{} Mult for every {C:mult}3{} energy removed",
						"{C:inactive}(Currently: {X:red,C:white}X#3#{}{C:inactive} Mult{}, {C:attention}#2#{} {C:inactive}Energy removed){}"
					}
				},
			j_tcy_hooh = {
				name = "Ho-oh",
				text = {
					"On {C:attention}first hand of round{}:",
					"If all {C:attention}4 suits{} present, leftmost",
					"card gains {C:dark_edition}Polychrome{} and {C:attention}seal{}",
					"{br:4}text needs to be here to work",
					"{X:mult,C:white}X#1#{} Mult per {C:dark_edition}Polychrome{} card in scored hand"
				}
			},
			j_tcy_trapinch = {
				name = 'Trapinch',
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"{br:3}text needs to be here to work",
					"{C:diamonds}Diamond{} cards in hand are automatically",
					"selected and cannot be deselected",
					"{C:inactive}(Evolves after {C:attention}#2#{}{C:inactive} rounds)"
				} 
			},
			j_tcy_vibrava = {
				name = 'Vibrava',
				text = {
					"{C:mult}+#1#{} Mult",
					"{br:3}text needs to be here to work",
					"First {C:diamonds}Diamond{} card scored each round",
					"grants {C:chips}+1{} hand",
					"{C:inactive}(Evolves after scoring {C:attention}#2#/25{}{C:inactive} {C:diamonds}Diamond{}{C:inactive} cards)"
				}
			},
			j_tcy_flygon = {
				name = 'Flygon',
				text = {
					"First {C:diamonds}Diamond{} card scored per round",
					"is enhanced",
					"First {C:diamonds}Diamond{} card scored per round",
					"grants {C:chips}+1{} hand",
					"{br:3}text needs to be here to work",
					"{X:mult,C:white}X0.1{} Mult per enhanced {C:diamonds}Diamond{} card in deck",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult)"
				}
			},
			j_tcy_spheal = {
				name = "Spheal",
				text = {
					"{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
					"{br:2}text needs to be here to work",
					"When a {C:attention}Glass{} card is scored:", 
					"Gain {C:chips}+4{} Chips and {C:mult}+2{} Mult with a",
					"{C:attention}Chance{} to halve {C:chips}Chips{} and {C:mult}Mult{}", 
					"{C:inactive,s:0.8}(Evolves after playing {C:attention,s:0.8}#3#{}{C:inactive,s:0.8}/2 Glass cards){}"
				}
			},
			j_tcy_sealeo = {
				name = "Sealeo",
				text = {
					"{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
					"{br:2}text needs to be here to work",
					"When a {C:attention}Glass{} card is scored:", 
					"Gain {C:chips}+8{} Chips and {C:mult}+4{} Mult with a",
					"{C:attention}Chance{} to halve {C:chips}Chips{} and {C:mult}Mult{}",
					"{C:inactive,s:0.8}(Evolves after playing {C:attention,s:0.8}#3#{}{C:inactive,s:0.8}/8 Glass cards){}"
				}
			},
			j_tcy_walrein = {
				name = "Walrein",
				text = {
					"{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
					"{br:2}text needs to be here to work",
					"When a {C:attention}Glass{} card is scored:", 
					"Gain {C:chips}+12{} Chips and {C:mult}+6{} Mult with a",
					"{C:attention}Chance{} to halve {C:chips}Chips{} and {C:mult}Mult",
					"{br:2}text needs to be here to work",
					"{X:mult,C:white}X#5#{} Mult per {C:attention}Glass{} card scored",
					"{C:inactive}(Currently {X:mult,C:white}X#6#{C:inactive} Mult)"
				}
			},
			j_tcy_heatran = {
				name = "Heatran",
				text = {
				"Create {C:attention}Immolate{} when a",
				"{C:attention}Big Blind{} or {C:attention}Boss Blind{} is selected", 
				"{br:2.5}text needs to be here to work",
				"Destroyed {C:attention}Steel Cards{} are {C:dark_edition}reforged{}",
				"{br:2.5}text needs to be here to work",
				"Trigger the {C:dark_edition}edition{} of {C:attention}Steel Cards{} scored from hand",
				}
			},
				j_tcy_larvesta = {
					name = 'Larvesta',
					text = {
						"{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
						"{br:3}text needs to be here to work",
						"{C:inactive}(Evolves when {C:attention}Sun{}{C:inactive} card is used)"
					}
				},
				j_tcy_volcarona = {
					name = 'Volcarona',
					text = {
						"Gain {X:mult,C:white}X#1#{} Mult for each",
						"{C:attention}Sun{} card owned at end of round",
						"{br:3}text needs to be here to work",
						"When {C:attention}Sun{} card used, double {X:mult,C:white}X{} Mult",
						"for current blind",
						"{br:3}text needs to be here to work",
						"Lose {X:mult,C:white}X#1#{} Mult per round without {C:attention}Sun{} cards",
						"{C:inactive}(Currently: {X:mult,C:white}X#2#{}{C:inactive} Mult)"
					}
				},
			j_tcy_xurkitree = {
				name = "Xurkitree",
				text = {
					"{C:attention}Steel{} cards in hand give {C:money}$#1#{}",
					"{C:attention}Gold{} cards in hand give {X:mult,C:white}X#2#{} Mult",
					"{br:3}text needs to be here to work",
					"Increase Mult by {X:mult,C:white}X1{} for every",
					"{C:attention}Steel{} and {C:attention}Gold{} card pair in your hand",
					"{C:inactive}(Currently: {X:mult,C:white}X#3#{})"
				}
			},
			j_tcy_guzzlord = {
				name = "Guzzlord",
				text = {
					"{C:dark}Guzzlord consumes everything in its path...{}",
					"{C:green}#1# in #2#{} chance to eat bought Jokers for {X:mult,C:white}+X0.29{} Mult",
					"{C:green}#1# in #2#{} chance to eat bought Consumables for {C:mult}+3{} Mult",
					"{C:green}#1# in #3#{} chance to eat discarded cards for {C:chips}+9{} Chips",
					"{C:inactive}(Currently: {X:mult,C:white}X#4#{}, {C:mult}+#5#{}, {C:chips}+#6#{})"
				}
			},
			j_tcy_stakataka = {
				name = 'Stakataka',
				text = {
					"Stacks {C:chips}Chips{} and {X:mult,C:white}X{} Mult for every",
					"{C:attention}prime number{} up to your full deck size",
					"{br:3}text needs to be here to work",
					"Next prime number: {C:attention}#5#{}",
					"{C:inactive}(Currently: {}{C:chips}+#3#{} Chips, {X:mult,C:white}X#4#{}{C:inactive}){}"
				}
			},
			j_tcy_blacephalon = {
				name = "Blacephalon",
				text = {
					"Cards discarded this {c:attention}Ante{} stack {C:mult}+3{} Mult",
					"{br:3}text needs to be here to work",
					"If {C:attention}leftmost{} joker:", 
					"{C:mult}+#1#{} Mult, gains {X:mult,C:white}X0.67{} Mult, and becomes debuffed",
					"{br:3}text needs to be here to work",
					"{C:attention}Resets{} debuffed state and {C:mult}Mult{} each ante",
					"{C:inactive}(Currently: {X:mult,C:white}X#2#{})"
				}
			}
        },
        Item = {
            c_tcy_loveball = {
                name = "Loveball",
                text = {
                    "Create a basic{C:attention} Joker{}",
                    "that you {C:fairy}Love!{}",
                    "{C:inactive}(Must have room)"
                }
            }
        
        },
        Spectral = {
			c_tcy_beastball = {
                name = "Beastball",
                text = {
                    "Create a random",
                    "{C:attention}Ultra Beast Joker{} card",
                    "{C:inactive}(Must have room)"
                },
            }
        },
        Other = {
			ultrabeast = {
                name = "Ultra Beast",
                text = {
                    "A Pokemon Joker",
                    "that is from another {C:attention}Dimension{}"
                },
			},
			ultrabeastdesc = {
                name = "Ultra Beast",
                text = {
                    "Can only be obtained",
                    "through certain {C:attention}Pokeball Items{}"
                } 
            }
        }
    },
    misc = {
        dictionary = {
			k_tcy_ultrabeast = "Ultra Beast",
            k_tcy_mega = "Mega",
			k_plus_hand = "+1 Hand",
			k_enhance = "Enhanced!",
            tcy_blazekick_ex = "Blaze Kick!",
			-- Lugia
            tcy_energy_drain = "Energy -1",
			tcy_energy_absorb = "Absorb!",
			-- Ho-oh
            tcy_sacred_fire_ex = "Sacred Fire!",
			-- From spheal line
			tcy_rollout_ex = "Rollout!",
			tcy_miss_ex = "Miss...",
			-- Heatran
			tcy_magma_storm_ex = "Magma Storm!",
			--- Volcarona
			tcy_sunny_day_ex = "Sunny Day!",
			tcy_mult_gain_ex = "Quiver Dance!",
			tcy_mult_loss_ex = "-0.2XMult",
			-- UB's
			tcy_boost_ex = "Beast Boost!",
			tcy_consume_ex = "Consume..."
        },
        --These are the Labels
        --You know how things like seals and editions have those badges at the bottom? That's what this is for!
        labels = {
			k_tcy_ultrabeast = "Ultra Beast"
        }
    }
}