require 'rexml/document'

# 1. Basic PR checks
warn("PR is still Work in Progress") if github.pr_title.include?("WIP")

# 2. Report Coverage
coverage_folder = "all-reports"

Dir.glob("#{coverage_folder}/reports-*/test_output/cobertura.xml").each do |xml_file|
  target_name = xml_file.match(/reports-(.+?)\//)[1]
  doc = REXML::Document.new(File.read(xml_file))
  coverage_element = doc.root
  overall_rate = coverage_element.attributes["line-rate"].to_f
  overall_percentage = (overall_rate * 100).to_i
  
  message("Code coverage for #{target_name}: #{overall_percentage}%")
  warn("Code coverage for #{target_name} is below 80%: #{overall_percentage}%") if overall_rate < 0.8

  # Build table for files
  table = "| File | Coverage |\n|------|----------|\n"
  files_added = 0

  doc.elements.each("//class") do |cls|
    file_name = cls.attributes["filename"]
    
    # --- FILTRO ADICIONADO AQUI ---
    # Verifica se o nome do arquivo termina com .swift
    next unless file_name.end_with?(".swift")
    
    line_rate = cls.attributes["line-rate"].to_f
    file_percentage = (line_rate * 100).to_i
    table += "| #{file_name} | #{file_percentage}% |\n"
    files_added += 1
  end

  # Só imprime a tabela se houver arquivos Swift encontrados
  if files_added > 0
    markdown("### Coverage Details for #{target_name}\n#{table}")
  end
end