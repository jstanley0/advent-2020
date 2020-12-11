$board = STDIN.readlines

def count_adj(board, row, col, ch)
  cnt = 0
  cnt += 1 if row > 0 && col > 0 && board[row - 1][col - 1] == ch
  cnt += 1 if row > 0 && board[row - 1][col] == ch
  cnt += 1 if row > 0 && col < board[row].size - 1 && board[row - 1][col + 1] == ch
  cnt += 1 if col > 0 && board[row][col - 1] == ch
  cnt += 1 if col < board[row].size - 1 && board[row][col + 1] == ch
  cnt += 1 if row < board.size - 1 && col > 0 && board[row + 1][col - 1] == ch
  cnt += 1 if row < board.size - 1 && board[row + 1][col] == ch
  cnt += 1 if row < board.size - 1 && col < board[row].size - 1 && board[row + 1][col + 1] == ch
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
        new_board[row][col] = 'L' if count_adj(board, row, col, '#') >= 4
      end
    end
  end
  new_board
end

board = $board
loop do
  puts board
  new_board = iter(board)
  break if new_board.join == board.join
  board = new_board
end

puts board.map{|row|row.count('#')}.sum
