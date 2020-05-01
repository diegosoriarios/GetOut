extends Control

func update_health_bar(curHp, maxHp):
	$HealthBar.max_value = maxHp
	$HealthBar.value = curHp

func update_ammo_text(ammo):
	$AmmoText.text = "Ammo: " + str(ammo)

func update_score_text(score):
	$ScoreText.text = "Score: " + str(score)
