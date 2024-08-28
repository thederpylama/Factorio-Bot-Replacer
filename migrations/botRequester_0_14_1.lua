for _, force in pairs(game.forces) do
  force.reset_recipes()
  force.reset_technologies()

  if force.technologies["construction-robotics"].researched then
    force.recipes["logistic-chest-botRequester"].enabled = true
  end
end