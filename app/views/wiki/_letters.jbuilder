letters = %w[а б в г д е ё ж з и й к л м н о п р с т у ф х ц ч ш щ ы э ю я]
current_letter ||= ''

json.links letters do |letter|
  if letter == current_letter
    json.self wiki_path(letter: letter, format: :json)
  else
    json.set! letter, wiki_path(letter: letter, format: :json)
  end
end
