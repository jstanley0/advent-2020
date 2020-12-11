$board = STDIN.readlines

def count_dir(board, row, col, ch, dr, dc)
  row += dr
  col += dc
  while (0...board.size).include?(row) && (0...board[row].size).include?(col)
    c = board[row][col]
    return 1 if c == ch
    break unless c == '.'
    row += dr
    col += dc
  end
  0
end

def count_adj(board, row, col, ch)
  cnt = 0
  cnt += count_dir(board, row, col, ch, -1, -1)
  cnt += count_dir(board, row, col, ch, -1, 0)
  cnt += count_dir(board, row, col, ch, -1, 1)
  cnt += count_dir(board, row, col, ch, 0, -1)
  cnt += count_dir(board, row, col, ch, 0, 1)
  cnt += count_dir(board, row, col, ch, 1, -1)
  cnt += count_dir(board, row, col, ch, 1, 0)
  cnt += count_dir(board, row, col, ch, 1, 1)
  cnt
end

def iter(board)
  new_board = board.map(&:dup)
  for row in 0...board.size
    for col in 0...board[row].size
      new_board[row][col] = board[row][col]
      case board[row][col]
      when 'L'
        new_board[row][col] = '#' if count_adj(board, row, col, '#') == 0
      when '#'
        new_board[row][col] = 'L' if count_adj(board, row, col, '#') >= 5
      end
    end
  end
  new_board
end

board = $board
loop do
  puts
  puts board
  new_board = iter(board)
  break if new_board.join == board.join
  board = new_board
end

puts board.map{|row|row.count('#')}.sum
