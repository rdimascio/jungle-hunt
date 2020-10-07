db.createUser({
	user: 'jungle_hunt',
	pwd: 'jh123!',
	roles: [
		{
			role: 'readWrite',
			db: 'jungleHunt',
		},
	],
})
