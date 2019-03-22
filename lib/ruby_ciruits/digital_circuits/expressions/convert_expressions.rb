def make_compatible(expr)
	# converting logical symbols to english keywords
	expr = expr.gsub('~&', ' NAND ')
    expr = expr.gsub('~|', ' NOR ')
    expr = expr.gsub('~^', ' XNOR ')
    expr = expr.gsub('&', ' AND ')
    expr = expr.gsub('|', ' OR ')
    expr = expr.gsub('~', ' NOT ')
    expr = expr.gsub('^', ' XOR ')
    return '((' + expr + '))'
end

def create_list(expr)
	list1 = expr.split('(')
	list2 = Array.new
	list3 = Array.new

	while
end