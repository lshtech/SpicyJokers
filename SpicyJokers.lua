--- STEAMODDED HEADER
--- MOD_NAME: SpicyJokers
--- MOD_ID: SpicyJokers
--- MOD_AUTHOR: [Richard]
--- MOD_DESCRIPTION: This mod adds two new jokers as of right now
--- BADGE_COLOUR: C9A926

----------------------------------------------
------------MOD CODE -------------------------

G.localization.misc.dictionary["k_lucky"] = "Lucky"

function SMODS.INIT.SpicyJokers()
    local seven = false;
    local joker_sprites = SMODS.Sprite:new('new_jokers', SMODS.findModByID("SpicyJokers").path, "sprites.png", 71, 95, "asset_atli")
    joker_sprites:register()

    local jokers = { -- Local Joker variables
        {
            name = "Gun Joker",
            slug = 'ssj_gun_joker',
            desc = {
                "{X:red,C:white}X#1#{} Mult on {C:attention}first",
                "{C:attention}hand{} of round"
            },
            config = {
                extra = 3
            },
            pos = {x = 0, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 1,
            cost = 3,
            loc_def = function(card) return {
                card.ability.extra} end,
            blueprint_compat = true,
            eternal_compat = true
        },
        {
            name = "Lucky Seven",
            slug = 'ssj_lucky_seven',
            desc = {
                "All Scored cards played with a {C:attention}7{}",
                "become {C:attention}Lucky{} cards"
            },
            config = {
                extra = 3
            },
            pos = {x = 1, y = 0}, -- POSITION IN SPRITE SHEET
            rarity = 2,
            cost = 4,
            blueprint_compat = false,
            eternal_compat = true

        }
    }


    for _, v in pairs(jokers) do -- ADDS Jokers to the demon
        joker = SMODS.Joker:new(
            v.name, 
            v.slug, 
            v.config,
            v.pos,
            {name = v.name, text = v.desc},
            v.rarity,
            v.cost, 
            nil, 
            nil, 
            v.blueprint_compat, 
            v.eternal_compat, 
            nil, 
            'new_jokers',
            nil
        )
        joker.loc_def = v.loc_def
        joker:register()
    end

    set_sprites_ref = Card.set_sprites
    Card.set_sprites = function(self, _center, _front)
        set_sprites_ref(self, _center, _front)
    end

    set_ability_ref = Card.set_ability
    Card.set_ability = function(self, center, initial, delay_sprites)
        set_ability_ref(self, center, initial, delay_sprites)
    end

    card_load_ref = Card.load
    Card.load = function(self, cardTable, other_card)
        card_load_ref(self, cardTable, other_card)
    end

    SMODS.Jokers.j_ssj_gun_joker.calculate = function(self, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.extra}},
                Xmult_mod = self.ability.extra
            }
        end
    end
    SMODS.Jokers.j_ssj_lucky_seven.calculate = function(self, context)
        if context.before and  context.cardarea == G.jokers then
            seven = false;
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 7 then seven = true end
            end
        end
        if not context.repetition and not context.other_joker and context.cardarea == G.jokers and context.before then
            if seven then
                for k, v in ipairs(context.scoring_hand) do
                    v:set_ability(G.P_CENTERS.m_lucky, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })) 
                end
                return {
                    message = localize('k_lucky'),
                    colour = G.C.MONEY,
                    card = self
                }
            end
        end

    end

    -- DECK FOR TESTING

    SMODS.Deck:new("test Deck", "ssj_test", { test = true, atlas = "b_mf_grosmichel" }, { x = 0, y = 0 }, {
        name = "test Deck",
        text = {
            "Testing deck to test stuff I add{C:attention} yeaaaa"
        }
    })
    :register()
    local Back_apply_to_run_ref = Back.apply_to_run
    function Back.apply_to_run(arg)
        Back_apply_to_run_ref(arg)
    
        -- Gros Michel Deck
        if arg.effect.config.test then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_ssj_lucky_seven', nil)
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    return true
                end
            }))
        end
    end
end


----------------------------------------------
------------MOD CODE END----------------------