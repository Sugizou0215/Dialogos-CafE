# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# ジャンルを追加
Genre.create!(
  [
    {
      name: '哲学カフェ（オンライン）'
    },
    {
      name: '哲学カフェ（オフライン）'
    },
    {
      name: '読書会（オンライン）'
    },
    {
      name: '読書会（オフライン）'
    },
    {
      name: 'その他'
    }
  ]
)
