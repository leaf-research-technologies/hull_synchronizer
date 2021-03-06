require 'fileutils'

module SubmissionHelper

  private

  def strip_csv_row(unstriped_row)
    row = {}
    unstriped_row.each do |k, v|
      row[k.strip] = v
      row[k.strip] = v.strip unless v.blank?
    end
    row
  end

  def get_data_path(filepath)
    return if filepath.blank?
    if is_remote_file?(filepath) or is_local_file?(filepath)
      sanitized_filepath(filepath).chomp(File::SEPARATOR)
    else
      File.join(@source_dir, sanitized_filepath(filepath)).chomp(File::SEPARATOR)
    end
  end

  def is_remote_file?(filename)
    sanitized_filepath(filename).start_with? File.join(FileLocations.remote_dir, File::SEPARATOR)
  end

  def is_local_file?(filename)
    sanitized_filepath(filename).start_with? File.join(@source_dir, File::SEPARATOR)
  end

  def sanitized_filepath(filename)
    # File name could contain either forward slash or back slash
    File.join(filename.strip.split /[\\\/]/)
  end

  def cleanup(src_dir, check_empty: true)
    if check_empty
      Dir.rmdir src_dir if Dir.empty?(src_dir)
    else
      FileUtils.rm_rf src_dir
    end
  end

end

