require 'test_helper'

class ProjectsTest < ActiveSupport::TestCase

  test "creates project" do
    Dir.mktmpdir do |tmp|
      projects_path = Pathname.new(tmp)
      Project.stubs(:dataroot).returns(projects_path)
      attrs = { dir: 'test_project' }
      project = Project.new(attrs)
      project.save

      assert Dir.entries(projects_path).include?("test_project")
    end
  end

  test "creates .ondemand configuration directory" do
    Dir.mktmpdir do |tmp|
      projects_path = Pathname.new(tmp)
      Project.stubs(:dataroot).returns(projects_path)
      attrs = { dir: 'test_project' }
      project = Project.new(attrs)
      project.save

      dot_ondemand_path = Pathname.new("#{projects_path}/#{project.dir}")

      assert Dir.entries(dot_ondemand_path).include?(".ondemand")
    end
  end

  test "creates manifest.yml in .ondemand config directory" do
    Dir.mktmpdir do |tmp|
      projects_path = Pathname.new(tmp)
      Project.stubs(:dataroot).returns(projects_path)
      attrs = { dir: 'test"authenticity_token"=>"[FILTERED]", "project"=>{"dir"=>"project4"}, "commit"=>"Save"}
      _project' }
      project = Project.new(attrs)
      project.save
      manifest_path = Pathname.new("#{projects_path}/#{project.dir}/.ondemand")

      assert Dir.entries(manifest_path).include?("manifest.yml")
    end
  end

  test "deletes project" do
    Dir.mktmpdir do |tmp|
      projects_path = Pathname.new(tmp)
      Project.stubs(:dataroot).returns(projects_path)
      attrs = { dir: 'test_project' }
      project = Project.new(attrs)
      project.save

      project.destroy!

      assert_not Dir.entries(projects_path).include?('test_project')
    end
  end

  test "update project manifest.yml file" do
    Dir.mktmpdir do |tmp|
      projects_path = Pathname.new(tmp)
      Project.stubs(:dataroot).returns(projects_path)
      attrs = { dir: 'test_project' }
      project = Project.new(attrs)
      project.save

      name          = 'galaxies and galaxies'
      description   = 'a view into the past'
      icon          = 'fa://abell_1689'

      test_attributes = {name: name, description: description, icon: icon }

      expected_manifest_yml = <<~HEREDOC
        ---
        name: galaxies and galaxies
        description: a view into the past
        icon: fa://abell_1689
      HEREDOC

      project.update(test_attributes)

      assert_equal expected_manifest_yml, File.read("#{project.manifest_path}")
    end
  end
end