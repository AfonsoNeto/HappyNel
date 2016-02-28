User.create(
	name: "Admin",
	email: "admin@happy.nel",
	password: "asdfg12345",
	role: User.roles[:admin]
) unless User.admins.any?

# Create members
User.create([
	{name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password, role: User.roles[:member]},
	{name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password, role: User.roles[:member]},
	{name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password, role: User.roles[:member]},
	{name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password, role: User.roles[:member]},
	{name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password, role: User.roles[:member]}
]) User.members.any?