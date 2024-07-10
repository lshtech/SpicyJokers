local jd_def = JokerDisplay.Definitions

jd_def['j_ssj_gun_joker'] = {
    line_1 = {
        {
            border_nodes = {
                { text = 'X', },
                {
                    ref_table = 'card.joker_display_values',
                    ref_value = 'xMult',
                },
            }
        }
    },
    line_2 = {
        { text = '(First Hand)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
    },
    
    calc_function = function(card)
        local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
        text, _, scoring_hand = JokerDisplay.evaluate_hand(hand)
        
        card.joker_display_values.xMult = G.GAME.current_round.hands_played == 0 and card.ability.extra or 1
    end,
}

jd_def['j_ssj_lucky_seven'] = {
    line_2 = {
        { text = '(', colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { text = '7', colour = G.C.IMPORTANT, scale = 0.3 },
        { text = ')', colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },        
    },
}

jd_def['j_ssj_business_joker'] = {
    line_1 = {
        { text = '+1', colour = G.C.SECONDARY_SET.Tarot },
    },
    line_2 = {
        { text = '(1 Hand)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
    },
}

jd_def['j_ssj_joker_squad'] = {
    line_1 = {
        { text = '+', colour = G.C.CHIPS },
        {
            ref_table = 'card.joker_display_values',
            ref_value = 'chips',
            colour = G.C.CHIPS,
        },
    },

    calc_function = function(card)
        local count = 0

        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.set == 'Joker' then
                count = count + 1
            end
        end

        card.joker_display_values.chips = card.ability.extra * count
    end
}

jd_def['j_ssj_antimatter_joker'] = {
    line_2 = {
        { text = '(+2 Slots)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },        
    },
}

jd_def['j_ssj_misfire'] = {
    line_1 = {
        {
            border_nodes = {
                { text = 'X', },
                {
                    ref_table = 'card.ability',
                    ref_value = 'extra',
                },
            }
        }
    },
    line_2 = {
        { text = '(1 in ', colour = G.C.GREEN, scale = 0.3 },
        {
            ref_table = 'card.ability',
            ref_value = 'extra',
            colour = G.C.GREEN,
            scale = 0.3
        },
        { text = ')', colour = G.C.GREEN, scale = 0.3 },
    },
}

jd_def['j_ssj_gnarled_throne'] = {
    line_1 = {
        { text = '+', colour = G.C.MULT },
        {
            ref_table = 'card.ability',
            ref_value = 'extra',
            colour = G.C.MULT,
        },
    },
}

jd_def['j_ssj_snr'] = {
    line_1 = {
        { text = '+', colour = G.C.MULT },
        {
            ref_table = 'card.ability',
            ref_value = 'extra',
            colour = G.C.MULT,
        },
    },
    line_2 = {
        { text = '(', colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        {
            ref_table = 'card.ability',
            ref_value = 'to_do_poker_hand',
            colour = G.C.UI.TEXT_INACTIVE,
            scale = 0.3
        },
        { text = ')', colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
    },
}

jd_def['j_ssj_sus'] = {
    line_1 = {
        {
            border_nodes = {
                { text = 'X' },
                {
                    ref_table = 'card.joker_display_values',
                    ref_value = 'xMult',
                },
            }
        }
    },
    line_2 = {
        { text = '(Stone Cards)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
    },
    
    calc_function = function(card)
        local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
        text, _, scoring_hand = JokerDisplay.evaluate_hand(hand)
        
        local count = 0

        for k, v in pairs(scoring_hand) do
            if v.label == "Stone Card" and not v.debuff then
                count = count + JokerDisplay.calculate_card_triggers(v, scoring_hand, nil)
            end
        end

        card.joker_display_values.xMult = count == 0 and 1 or tonumber(string.format("%.2f", (card.ability.extra ^ count)))
    end,
}