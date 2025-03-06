-- Wellcome to vi.lua
-- credit by : Huycorn
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
						"Khi blind được chọn, loại bỏ một",
						"năng lượng khỏi lá Joker",
						"hệ {X:fire,C:white}Lửa{}, {X:lightning}Lôi{}, và {X:water,C:white}Thuỷ",
						"{br:4}text needs to be here to work",
						"{X:red,C:white}X4{} Nhân cho {C:mult}3{} năng lượng được loại bỏ",
						"{C:inactive}(Hiện tại: {X:red,C:white}X#3#{}{C:inactive} Nhân{}, {C:attention}#2#{} {C:inactive}Năng lượng được loại bỏ){}"
					}
				},
			j_tcy_hooh = {
				name = "Ho-oh",
				text = {
					"Trên {C:attention}tay đầu của ván{}:",
					"Nếu có mặt toàn bộ {C:attention}4 chất{}, lá",
					"tít bên trái cho {C:dark_edition}Đa Sắc{} và {C:attention}ấn{}",
					"{br:4}text needs to be here to work",
					"{X:mult,C:white}X#1#{} Nhân mỗi lá {C:dark_edition}Đa Sắc{} có trên tay bài ghi điểm"
				}
			},
			j_tcy_trapinch = {
				name = 'Trapinch',
				text = {
					"{X:mult,C:white}X#1#{} Nhân",
					"{br:3}text needs to be here to work",
					"Lá {C:diamonds}Rô{} trong tay đều tự động",
					"được chọn và không thể huỷ chọn",
					"{C:inactive}(Tiến hoá sau {C:attention}#2#{}{C:inactive} ván)"
				} 
			},
			j_tcy_vibrava = {
				name = 'Vibrava',
				text = {
					"{C:mult}+#1#{} Nhân",
					"{br:3}text needs to be here to work",
					"Lá {C:diamonds}Rô{} đã ghi điểm đầu tiên mỗi ván",
					"thêm {C:chips}+1{} tay bài",
					"{C:inactive}(Tiến hoá sau ghi {C:attention}#2#/25{}{C:inactive} lá {C:diamonds}Rô{}{C:inactive})"
				}
			},
			j_tcy_flygon = {
				name = 'Flygon',
				text = {
					"Lá {C:diamonds}Rô{} được ghi điểm mỗi ván",
					"được cường hoá",
					"Lá {C:diamonds}Rô{} được ghi điểm mỗi ván",
					"nhận {C:chips}+1{} tay bài",
					"{br:3}text needs to be here to work",
					"{X:mult,C:white}X0.1{} Nhân mỗi lá {C:diamonds}Rô{} được cường hoá trong bộ bài",
					"{C:inactive}(Hiện tại {X:mult,C:white}X#2#{}{C:inactive} Nhân)"
				}
			},
			j_tcy_spheal = {
				name = "Spheal",
				text = {
					"{C:chips}+#1#{} Chip và {C:mult}+#2#{} Nhân",
					"{br:2}text needs to be here to work",
					"Khi một lá {C:attention}Kính{} được ghi điểm:", 
					"Nhận {C:chips}+4{} Chip và {C:mult}+2{} Nhân cùng ột",
					"{C:attention}Cơ hội{} chia nửa {C:chips}Chip{} và {C:mult}Nhân{}", 
					"{C:inactive,s:0.8}(Tiến hoá sau khi chơi {C:attention,s:0.8}#3#{}{C:inactive,s:0.8}/2 lá Kính){}"
				}
			},
			j_tcy_sealeo = {
				name = "Sealeo",
				text = {
					"{C:chips}+#1#{} Chip và {C:mult}+#2#{} Nhân",
					"{br:2}text needs to be here to work",
					"Khi một lá {C:attention}Kính{} được ghi điểm:", 
					"Nhận {C:chips}+8{} Chip và {C:mult}+4{} Nhân cùng với",
					"{C:attention}Cơ hội{} chia nửa {C:chips}Chip{} và {C:mult}Nhân{}",
					"{C:inactive,s:0.8}(Tiến hoá sau khi chơi {C:attention,s:0.8}#3#{}{C:inactive,s:0.8}/8 lá Kính){}"
				}
			},
			j_tcy_walrein = {
				name = "Walrein",
				text = {
					"{C:chips}+#1#{} Chip và {C:mult}+#2#{} Nhân",
					"{br:2}text needs to be here to work",
					"Khi một lá {C:attention}Kính{} được ghi điểm:", 
					"Nhận {C:chips}+12{} Chip và {C:mult}+6{} Nhân cùng một",
					"{C:attention}Cơ hội{} chia nửa {C:chips}Chip{} và {C:mult}Nhân",
					"{br:2}text needs to be here to work",
					"{X:mult,C:white}X#5#{} Nhân mỗi lá {C:attention}Kính{} đã ghi điểm",
					"{C:inactive}(Hiện tại {X:mult,C:white}X#6#{C:inactive} Nhân)"
				}
			},
			j_tcy_heatran = {
				name = "Heatran",
				text = {
				"Tạo một {C:attention}Nguyền Chú{} khi một",
				"{C:attention}Big Blind{} hoặc {C:attention}Boss Blind{} được chọn", 
				"{br:2.5}text needs to be here to work",
				"Mọi {C:attention}Lá Thép{} bị phá huỷ được {C:dark_edition}rèn lại{}",
				"{br:2.5}text needs to be here to work",
				"Kích hoạt {C:dark_edition}ấn bản{} của các {C:attention}Lá Thép{} được ghi điểm từ tay",
				}
			},
			j_tcy_xurkitree = {
				name = "Xurkitree",
				text = {
					"Lá {C:attention}Thép{} trong tay cho {C:money}$#1#{}",
					"Lá {C:attention}Vàng{} trong tay cho {X:mult,C:white}X#2#{} Nhân",
					"{br:3}text needs to be here to work",
					"Tăng hệ số nhân lên {X:mult,C:white}X1{} cho mọi lá",
					"{C:attention}Thép{} và {C:attention}Vàng{} cầm trên tay",
					"{C:inactive}(Hiện tại: {X:mult,C:white}X#3#{})"
				}
			},
			j_tcy_guzzlord = {
				name = "Guzzlord",
				text = {
					"{C:dark}Guzzlord tiêu thụ mọi thứ trên đường đi của nó...{}",
					"{C:green}#1# trên #2#{} khả năng ăn Joker đã mua và cho {X:mult,C:white}+X0.29{} Nhân",
					"{C:green}#1# trên #2#{} khả năng ăn Vật Phẩm đã mua và cho {C:mult}+3{} Nhân",
					"{C:green}#1# trên #3#{} khả năng ăn lá bài được loại bỏ và cho {C:chips}+9{} Chip",
					"{C:inactive}(Hiện tại: {X:mult,C:white}X#4#{}, {C:mult}+#5#{}, {C:chips}+#6#{})"
				}
			},
			j_tcy_stakataka = {
				name = 'Stakataka',
				text = {
					"Gộp {C:chips}Chip{} và {X:mult,C:white}X{} Nhân cho mọi",
					"{C:attention}số nguyên tố{} lên đến kích thước bộ bài đầy đủ của bạn",
					"{br:3}text needs to be here to work",
					"Số nguyên tố tiếp theo: {C:attention}#5#{}",
					"{C:inactive}(Hiện tại: {}{C:chips}+#3#{} Chip, {X:mult,C:white}X#4#{}{C:inactive}){}"
				}
			},
			j_tcy_blacephalon = {
				name = "Blacephalon",
				text = {
					"Các lá bài bị loại bỏ trong {c:attention}Ante{} này chồng lên {C:mult}+3{} Nhân",
					"{br:3}text needs to be here to work",
					"Nếu lá Joker {C:attention}tít bên trái{}:", 
					"{C:mult}+#1#{} Nhân, nhận {X:mult,C:white}X0.67{} Nhân, rồi bị vô hiệu",
					"{br:3}text needs to be here to work",
					"{C:attention}Đặt lại{} trạng thái bị suy yếu và {C:mult}Nhân{} mỗi ante",
					"{C:inactive}(Hiện tại: {X:mult,C:white}X#2#{})"
				}
			}
        },
        Item = {
            c_tcy_loveball = {
                name = "Loveball",
                text = {
                    "Tạo một lá{C:attention} Joker{} tiêu chuẩn",
                    "mà bạn {C:fairy}Thích!{}",
                    "{C:inactive}(Cần ô trống)"
                }
            }
        
        },
        Spectral = {
			c_tcy_beastball = {
                name = "Beastball",
                text = {
                    "Tạo ngẫu nhiên",
                    "lá {C:attention}Joker Siêu Quái Thú{}",
                    "{C:inactive}(Cần ô trống)"
                },
            }
        },
        Other = {
			ultrabeast = {
                name = "Siêu Quái Thú",
                text = {
                    "Một lá Joker Pokermon",
                    "đến từ {C:attention}Chiều không gian{} khác"
                },
			},
			ultrabeastdesc = {
                name = "Siêu Quái Thú",
                text = {
                    "Chỉ có thể nhận",
                    "thông qua {C:attention}Pokeball{} nhất định"
                } 
            }
        }
    },
    misc = {
        dictionary = {
			k_tcy_ultrabeast = "Siêu Quái Thú",
            k_tcy_mega = "Siêu Cấp",
			k_plus_hand = "+1 Tay bài",
			k_enhance = "Đã Cường Hoá!",
            tcy_blazekick_ex = "Liệt Cước!",
			-- Lugia
            tcy_energy_drain = "-1 Năng Lượng",
			tcy_energy_absorb = "Hấp Thụ!",
			-- Ho-oh
            tcy_sacred_fire_ex = "Hoả Thánh!",
			-- From spheal line
			tcy_rollout_ex = "Triển khai!",
			tcy_miss_ex = "Trượt...",
			-- Heatran
			tcy_magma_storm_ex = "Bão nham thạch!",
			-- UB's
			tcy_boost_ex = "Quái thú Tăng cường!",
			tcy_consume_ex = "Tiêu thụ..."
        },
        --These are the Labels
        --You know how things like seals and editions have those badges at the bottom? That's what this is for!
        labels = {
			k_tcy_ultrabeast = "Quái Thú"
        }
    }
}